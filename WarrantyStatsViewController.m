//
//  WarrantyStatsViewController.m
//  myInventory
//
//  Created by amar tk on 15/04/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "WarrantyStatsViewController.h"
#import "DBManager.h"
#import "InventoryItem.h"

#define NO_ITEMS_LABEL_TAG  100

@interface WarrantyStatsViewController ()
{
    DBManager *dbManager;
    NSMutableArray *availableItems;
    NSDateFormatter *dateFormatter;
}

@end

@implementation WarrantyStatsViewController

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
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    availableItems = [dbManager getItemsSortedByWarrantyDate];
    
    if (availableItems.count > 0) {
        [[self.view viewWithTag:NO_ITEMS_LABEL_TAG] removeFromSuperview];
        [self.tableView reloadData];
        
    } else {
        UILabel *noItemsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        noItemsLabel.text = @"You need to add items to view stats";
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [availableItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"WarrantyCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WarrantyCell"];
    }
    
    InventoryItem *inventoryItem = (InventoryItem *)[availableItems objectAtIndex:indexPath.row];
    NSArray *cellContentViews = [cell.contentView subviews];
    UILabel *itemNameLabel = (UILabel *)[cellContentViews objectAtIndex:0];
    UILabel *warrantyDateLabel = (UILabel *)[cellContentViews objectAtIndex:2];

    itemNameLabel.text = inventoryItem.name;
    
    itemNameLabel.adjustsFontSizeToFitWidth = YES;
    
    warrantyDateLabel.text = [NSString stringWithFormat:@"%@", inventoryItem.warrantyDate];
    
    NSDate *warrantyDate = [dateFormatter dateFromString:inventoryItem.warrantyDate];
    if ([warrantyDate compare:[NSDate date]] == NSOrderedAscending) {
        warrantyDateLabel.textColor = [UIColor redColor];
    } else {
        warrantyDateLabel.textColor = [UIColor greenColor];
    }
    
    warrantyDateLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
