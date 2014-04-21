//
//  ItemsViewController.m
//  myInventory
//
//  Created by amar tk on 02/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "ItemsViewController.h"
#import "ItemsCell.h"
#import "InventoryItem.h"
#import "DBManager.h"
#import "UIView+Toast.h"

#define NO_ITEMS_LABEL_TAG  100

@interface ItemsViewController ()
{
    NSMutableDictionary *availableItems;
    NSArray *filteredItems;
    DBManager *dbManager;
}
@end

@implementation ItemsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager = [[DBManager alloc] init];
    
    // Hide the search bar until user scrolls up
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y +  self.searchDisplayController.searchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.searchDisplayController isActive]) {
        availableItems = [[dbManager getAllItems] objectForKey:@"ITEMS_LIST"];
        [self handleZeroItems];
        [self.tableView reloadData];
        
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleZeroItems
{
    [[self.view viewWithTag:NO_ITEMS_LABEL_TAG] removeFromSuperview];
    if (availableItems.count > 0) {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    } else {
        UILabel *noItemsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        noItemsLabel.text = @"No Items Added";
        [noItemsLabel sizeToFit];
        noItemsLabel.center = self.view.center;
        [noItemsLabel setTag:NO_ITEMS_LABEL_TAG];
        [self.view addSubview:noItemsLabel];
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return [[availableItems allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredItems count];
    }
    return [[availableItems valueForKey:[[[availableItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.frame.size.width, 18)];
    [headerLabel setFont:[UIFont systemFontOfSize:13]];
    [headerLabel setText:[[[[availableItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section] uppercaseString]];
    [headerView addSubview:headerLabel];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";

    ItemsCell *cell = (ItemsCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (ItemsCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    InventoryItem *inventoryItem;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        inventoryItem = (InventoryItem *)[filteredItems objectAtIndex:indexPath.row];
        
    } else {
        inventoryItem = (InventoryItem *)[[availableItems valueForKey:[[[availableItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    
    cell.itemName.text = inventoryItem.name;
    cell.itemImage.image = [UIImage imageNamed:inventoryItem.imageName];
    
    // Configure the cell...
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the item from DB
        InventoryItem *inventoryItem = (InventoryItem *)[[availableItems valueForKey:[[[availableItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        [dbManager deleteItemWithId:inventoryItem.itemId];

        // hide cell, because animations are broken on ios7 for last remaining row
        if (IS_IOS_7_OR_LATER && [[availableItems valueForKey:[[[availableItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] count] == 1) {
            [tableView cellForRowAtIndexPath:indexPath].alpha = 0.0;
        }
        
        [[availableItems valueForKey:[[[availableItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        tableView.rowHeight = 66.0f;
        availableItems = [[dbManager getAllItems] objectForKey:@"ITEMS_LIST"];
        [self handleZeroItems];
        [tableView reloadData];
    }
}

#pragma mark - Search Bar delegate -

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"name contains[cd] %@",
                                    searchText];

    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSString *key in [availableItems allKeys]) {
        [arr addObjectsFromArray:[availableItems objectForKey:key]];
        
    }

    filteredItems = [arr filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 66.0f;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        
        UINavigationController *newItemNavController = segue.destinationViewController;
        NewItemViewController *newItemViewController = (NewItemViewController *)[[newItemNavController viewControllers] objectAtIndex:0];
        newItemViewController.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"DetailItem"]) {
        
        DetailItemsViewController *detailItemsViewController = (DetailItemsViewController *)segue.destinationViewController;
        
        NSIndexPath *path = nil;
        InventoryItem *item;
        if ([self.searchDisplayController isActive]) {
            path = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            item = [filteredItems objectAtIndex:path.row];
        } else {
            path = [self.tableView indexPathForSelectedRow];
            item = [[availableItems valueForKey:[[[availableItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:path.section]] objectAtIndex:path.row];
        }
        

        detailItemsViewController.inventoryItem = item;
        detailItemsViewController.delegate = self;
    }
}

#pragma mark - NewItemDelegate -

-(void)newItemAdded:(InventoryItem *)inventoryItem
{
    inventoryItem.itemId = [dbManager insertIntoItemsTable:inventoryItem];
    [[availableItems objectForKey:[inventoryItem.name substringToIndex:1]] addObject:inventoryItem];
    [self dismissViewControllerAnimated:YES completion:^{
        CGPoint toastPos = self.tabBarController.tabBar.frame.origin;
        toastPos.y = toastPos.y - 50;
        toastPos.x = self.tabBarController.tabBar.frame.size.width / 2;
        [self.tabBarController.view makeToast:@"New item added successfully" duration:2.0f position:[NSValue valueWithCGPoint:toastPos]];
    }];
}

-(void)addItemCancelled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -Detail Items Delegate -

-(void)deleteItemWithId:(NSInteger)itemId
{
    [dbManager deleteItemWithId:itemId];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSLog(@"delete button was pressed");
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}


@end
