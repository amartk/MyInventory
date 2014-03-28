//
//  TotalAssetViewController.m
//  myInventory
//
//  Created by amar tk on 20/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "TotalAssetViewController.h"
#import "AssetTableViewCell.h"

@interface TotalAssetViewController ()

@end

@implementation TotalAssetViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 1) {
        return 1;
    }
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AssetCell";
    AssetTableViewCell *cell = (AssetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[AssetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.nameLabel.text = @"Name";
    cell.totalValueLabel.text = [NSString stringWithFormat:@"₹ %@", @"26"];
    cell.multiplierLabel.text = @"2 x 13";
    // Configure the cell...
    
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

*/

-(void)chooseSortFieldTapped:(id)sender
{
    if (_sorterPickerViewController == nil) {
        _sorterPickerViewController = [[SortPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        _sorterPickerViewController.delegate = self;
    }
    
    if (_sorterPickerPopOver == nil) {
        _sorterPickerPopOver = [[UIPopoverController alloc] initWithContentViewController:_sorterPickerViewController];
        
        [_sorterPickerPopOver presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
    } else {
        [_sorterPickerPopOver dismissPopoverAnimated:YES];
        _sorterPickerPopOver = nil;
    }
}

@end
