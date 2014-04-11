//
//  CategoryViewController.m
//  myInventory
//
//  Created by amar tk on 02/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "CategoryViewController.h"
#import "InventoryCategory.h"
#import "CategoryCell.h"
#import "DBManager.h"

@interface CategoryViewController ()
{
    NSMutableArray *availableCategories;
    DBManager *dbManager;
}
@end

@implementation CategoryViewController

//-(void)deleteCategoryWithId:(NSInteger)categoryId
//{
//    [availableCategories removeObjectAtIndex:categoryId];
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    [self.tableView reloadData];
//}

#pragma mark - NewCategoryViewControllerDelegate -

-(void)didAddCategory:(InventoryCategory *)category
{
    [availableCategories addObject:category];
    [dbManager insertIntoCategoryTable:category];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[availableCategories count] -1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    availableCategories = [dbManager getAllCategories];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return availableCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    CategoryCell *cell = (CategoryCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = (CategoryCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    InventoryCategory *inventoryCategory = [availableCategories objectAtIndex:indexPath.row];
    cell.mNameLabel.text = inventoryCategory.name;
    cell.mImageView.image = [UIImage imageNamed:inventoryCategory.imageName];
    // Configure the cell...
    
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Dont allow to delete the general category
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

// Override to support editing the table view.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Update all the items with this category to General category
        
        InventoryCategory *inventoryCategory = (InventoryCategory *)[availableCategories objectAtIndex:indexPath.row];
        
        [dbManager deleteCategoryWithId:inventoryCategory.categoryId];

        [availableCategories removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Search Bar Delegates -

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tableView reloadData];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 66.0f;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddCategory"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        NewCategoryViewController *newCategoryViewController = (NewCategoryViewController *)[[navigationController viewControllers] objectAtIndex:0];
        newCategoryViewController.delegate = self;
        
    } else  if ([segue.identifier isEqualToString:@"DetailCategory"]) {
        CategoryDetailsViewController *categoryDetailsViewController = (CategoryDetailsViewController *)segue.destinationViewController;
        //categoryDetailsViewController.delegate = self;
        categoryDetailsViewController.categoryId = [self.tableView indexPathForSelectedRow].row;
        categoryDetailsViewController.category = [availableCategories objectAtIndex:categoryDetailsViewController.categoryId];
    }
}

@end
