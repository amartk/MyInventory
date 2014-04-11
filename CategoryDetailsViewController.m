//
//  CategoryDetailsViewController.m
//  myInventory
//
//  Created by amar tk on 08/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "CategoryDetailsViewController.h"
#import "DMManager/DBManager.h"
#import "ItemsCell.h"

#define NO_ITEMS_LABEL_TAG  100

@interface CategoryDetailsViewController ()
{
    DBManager *dbManager;
    NSMutableDictionary *availableItems;
}
@end

@implementation CategoryDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dbManager = [[DBManager alloc] init];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

-(void)viewWillAppear:(BOOL)animated
{
    [_categoryDescriptionTextView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    if (!_categoryId) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self setcategoryTableViewBorder];
    
    _categoryImage.image = [UIImage imageNamed:_category.imageName];
    _categoryDescriptionTextView.text = _category.description;
    self.title = _category.name;

    availableItems = [dbManager getAllItemsWithCategory:_category.categoryId];
    
    if (availableItems.count > 0) {
        [[self.view viewWithTag:NO_ITEMS_LABEL_TAG] removeFromSuperview];
        _categoryItemsTableView.alwaysBounceVertical = NO;
        [_categoryItemsTableView reloadData];
    } else {
        _categoryItemsTableView.alwaysBounceVertical = NO;
        UILabel *noItemsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        noItemsLabel.text = @"No items added to this category";
        [noItemsLabel sizeToFit];
        noItemsLabel.center = self.view.center;
        [noItemsLabel setTag:NO_ITEMS_LABEL_TAG];
        [self.view addSubview:noItemsLabel];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_categoryDescriptionTextView removeObserver:self forKeyPath:@"contentSize"];
    [_categoryDescriptionTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setcategoryTableViewBorder
{
    CALayer *layer = _categoryItemsTableView.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [[UIColor grayColor] CGColor];
    layer.cornerRadius = 8;
    layer.masksToBounds = YES;
}

//- (IBAction)deleteCategory:(id)sender {
//    [_delegate deleteCategoryWithId:_categoryId];
//}


#pragma mark - Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[availableItems allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[availableItems valueForKey:[[[availableItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    
    ItemsCell *cell = (ItemsCell *)[_categoryItemsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (ItemsCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    InventoryItem *inventoryItem = (InventoryItem *)[[availableItems valueForKey:[[[availableItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.itemName.text = [NSString stringWithFormat:@"%@", inventoryItem.name];
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
        
        [[availableItems valueForKey:[[availableItems allKeys] objectAtIndex:indexPath.section]] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (availableItems.count == 0) {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self.view];
    CGPoint textViewPoint = [_categoryDescriptionTextView convertPoint:location fromView:self.view];
    if (![_categoryDescriptionTextView pointInside:textViewPoint withEvent:event]) {
        [_categoryDescriptionTextView resignFirstResponder];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [dbManager updateCategoryDescriptionTo:textView.text forCategory:_category.categoryId];
    [_categoryDescriptionTextView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_categoryDescriptionTextView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        
        UINavigationController *newItemNavController = segue.destinationViewController;
        NewItemViewController *newItemViewController = (NewItemViewController *)[[newItemNavController viewControllers] objectAtIndex:0];
        newItemViewController.delegate = self;
    }
    
}

#pragma mark - NewItemDelegate -

-(void)newItemAdded:(InventoryItem *)inventoryItem
{
    //inventoryItem.itemId = [dbManager insertIntoItemsTable:inventoryItem];
    //[[availableItems objectForKey:[inventoryItem.name substringToIndex:1]] addObject:inventoryItem];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addItemCancelled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
