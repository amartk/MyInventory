//
//  SortPickerViewController.m
//  myInventory
//
//  Created by amar tk on 22/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "SortPickerViewController.h"

@interface SortPickerViewController ()

@end

@implementation SortPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _sorterNames = [NSMutableArray array];
        
        [_sorterNames addObject:@"Item"];
        [_sorterNames addObject:@"Category"];
        [_sorterNames addObject:@"Vendor"];
        
        self.clearsSelectionOnViewWillAppear = NO;
        
        NSInteger rowsCount = [_sorterNames count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        CGFloat largestWidth = 0;
        for (NSString *sorterName in _sorterNames) {
            CGSize labelSize = [sorterName sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
            if (labelSize.width > largestWidth) {
                largestWidth = labelSize.width;
            }
        }
        
        CGFloat popOverwidth = largestWidth + 100;
        
        self.contentSizeForViewInPopover = CGSizeMake(popOverwidth, totalRowsHeight);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_sorterNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text = [_sorterNames objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedSorter = [_sorterNames objectAtIndex:indexPath.row];
    [_delegate seletedSorterField:selectedSorter];
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

@end
