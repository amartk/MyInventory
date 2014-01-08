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
#import "constants.h"

@interface CategoryViewController ()
{
    NSMutableArray *availableCategories;
    NSString *categoryFile;
}
@end

@implementation CategoryViewController

-(void)deleteCategoryWithId:(NSInteger)categoryId
{
    [availableCategories removeObjectAtIndex:categoryId];
    [NSKeyedArchiver archiveRootObject:availableCategories toFile:categoryFile];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}

#pragma mark - NewCategoryViewControllerDelegate -

-(void)didAddCategory:(InventoryCategory *)category
{
    [availableCategories addObject:category];
    [NSKeyedArchiver archiveRootObject:availableCategories toFile:categoryFile];

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
    
    //Check if there is a file present with the list of categories
    //if not then create the categories here
    NSString *documentsDir = [self applicationDocumentsDirectory];
    
    categoryFile = [NSString stringWithFormat:@"%@/%@", documentsDir, CATEGORY_FILE];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:categoryFile]) {
        availableCategories = [NSKeyedUnarchiver unarchiveObjectWithFile:categoryFile];
    } else {
        [self createDefaultCategories];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
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
    cell.mImageView.image = inventoryCategory.image;
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
        [availableCategories removeObjectAtIndex:indexPath.row];
        [NSKeyedArchiver archiveRootObject:availableCategories toFile:categoryFile];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
        categoryDetailsViewController.delegate = self;
        categoryDetailsViewController.categoryId = [self.tableView indexPathForSelectedRow].row;
    }
}

#pragma mark -

-(void) createDefaultCategories
{
    availableCategories = [NSMutableArray arrayWithObjects:
                           [[InventoryCategory alloc] initWithName:@"General" withImage:[UIImage imageNamed:@"Object.png"]],
                           [[InventoryCategory alloc] initWithName:@"Books" withImage:[UIImage imageNamed:@"category_books.png"]],
                           [[InventoryCategory alloc] initWithName:@"Clothing" withImage:[UIImage imageNamed:@"category_clothing.png"]],
                           [[InventoryCategory alloc] initWithName:@"Electronics" withImage:[UIImage imageNamed:@"Object.png"]],
                           [[InventoryCategory alloc] initWithName:@"Entertainment" withImage:[UIImage imageNamed:@"category_entertainment.png"]], nil];
    [NSKeyedArchiver archiveRootObject:availableCategories toFile:categoryFile];
}


@end
