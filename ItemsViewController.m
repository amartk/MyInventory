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

#define NO_ITEMS_LABEL_TAG  100


@interface ItemsViewController ()
{
    NSMutableArray *availableItems;
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    availableItems = [dbManager getAllItems];
    [self.tableView reloadData];
    
    if (availableItems.count > 0) {
        [[self.view viewWithTag:NO_ITEMS_LABEL_TAG] removeFromSuperview];
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    } else {
        
        UILabel *noItemsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        noItemsLabel.text = @"No Items Added";
        [noItemsLabel sizeToFit];
        noItemsLabel.center = self.view.center;
        [noItemsLabel setTag:NO_ITEMS_LABEL_TAG];
        [self.view addSubview:noItemsLabel];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return availableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";

    ItemsCell *cell = (ItemsCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (ItemsCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    InventoryItem *inventoryItem = (InventoryItem *)[availableItems objectAtIndex:indexPath.row];
    //cell.itemName.text = inventoryItem.name ;
    cell.itemName.text = [NSString stringWithFormat:@"%@ %@", inventoryItem.name , inventoryItem.categoryName];
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
        InventoryItem *inventoryItem = (InventoryItem *)[availableItems objectAtIndex:indexPath.row];
        
        [dbManager deleteItemWithId:inventoryItem.itemId];
        
        [availableItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        if (availableItems.count == 0) {
            self.navigationItem.leftBarButtonItem = nil;
        }
        
    }
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
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        InventoryItem *item = [availableItems objectAtIndex:path.row];
        detailItemsViewController.inventoryItem = item;
        detailItemsViewController.delegate = self;
    }

}

#pragma mark - NewItemDelegate -

-(void)newItemAdded:(InventoryItem *)inventoryItem
{
    inventoryItem.itemId = [dbManager insertIntoItemsTable:inventoryItem];
    [availableItems addObject:inventoryItem];
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
