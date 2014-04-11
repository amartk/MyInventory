//
//  TotalAssetViewController.m
//  myInventory
//
//  Created by amar tk on 20/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "TotalAssetViewController.h"
#import "AssetTableViewCell.h"
#import "DBManager.h"
#import "SortPickerViewController.h"
#import "WYPopoverController.h"

#define NO_ITEMS_LABEL_TAG  100

@interface TotalAssetViewController () <WYPopoverControllerDelegate>
{
    DBManager *dbManager;
    NSMutableDictionary *availableItems;
    float totalInventoryWorth;
    NSNumber *from, *to;
    float startTime;
    WYPopoverController *settingsPopoverController;
}
@end

@implementation TotalAssetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager = [[DBManager alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTableViewBorder];
    
    NSMutableDictionary *allItemsDetails = [dbManager getAllItems];
    availableItems = [allItemsDetails objectForKey:@"ITEMS_LIST"];
    totalInventoryWorth = [[allItemsDetails objectForKey:@"TOTAL_VALUE"] floatValue];
    
    [_splitterTableView reloadData];
    
    if (availableItems.count > 0) {
        [[self.view viewWithTag:NO_ITEMS_LABEL_TAG] removeFromSuperview];
    } else {
        UILabel *noItemsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        noItemsLabel.text = @"You need to add items to view stats";
        [noItemsLabel sizeToFit];
        noItemsLabel.center = self.view.center;
        [noItemsLabel setTag:NO_ITEMS_LABEL_TAG];
        [self.view addSubview:noItemsLabel];
    }
    [self animateFrom:[NSNumber numberWithFloat:0.00] toNumber:[NSNumber numberWithFloat:totalInventoryWorth]];
}

- (void)animateFrom:(NSNumber *)aFrom toNumber:(NSNumber *)aTo {
    from = aFrom;
    to = aTo;
    _totalWorthLabel.text = [aFrom stringValue];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateNumber:)];
    
    startTime = CACurrentMediaTime();
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)animateNumber:(CADisplayLink *)link {
    static float DURATION = 1.0;
    float dt = ([link timestamp] - startTime) / DURATION;
    if (dt >= 1.0) {
        _totalWorthLabel.text = [NSString stringWithFormat:@"%0.2f", totalInventoryWorth];
        [link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        return;
    }
    
    float current = ([to floatValue] - [from floatValue]) * dt + [from floatValue];
    _totalWorthLabel.text = [NSString stringWithFormat:@"%0.2f", current];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableViewBorder
{
    CALayer *layer = _splitterTableView.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [[UIColor grayColor] CGColor];
    layer.cornerRadius = 4;
    layer.masksToBounds = YES;
}

#pragma mark - Table view data source

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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[availableItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.frame.size.width, 18)];
    [headerLabel setFont:[UIFont systemFontOfSize:13]];
    [headerLabel setText:[[[[availableItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section] uppercaseString]];
    [headerView addSubview:headerLabel];
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AssetCell";
    AssetTableViewCell *cell = (AssetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[AssetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    InventoryItem *inventoryItem = (InventoryItem *)[[availableItems valueForKey:[[[availableItems allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = inventoryItem.name;
    //cell.totalValueLabel.text = [NSString stringWithFormat:@"₹ %@", inve];
    float totalPrice = inventoryItem.quantity * inventoryItem.price;
    cell.totalValueLabel.text = [NSString stringWithFormat:@"₹ %0.2f", totalPrice];
    cell.multiplierLabel.text = [NSString stringWithFormat:@"%d x %0.2f", inventoryItem.quantity, inventoryItem.price];
    // Configure the cell...
    
    return cell;
}

-(void)chooseSortFieldTapped:(id)sender
{
//    if (settingsPopoverController == nil) {
//        UIView *btn = (UIView *)sender;
//        
//        SortPickerViewController *settingsViewController = [[SortPickerViewController alloc] initWithStyle:UITableViewStylePlain];
//        settingsViewController.preferredContentSize = CGSizeMake(320, 280);
//        
//        settingsViewController.title = @"Settings";
//
//        UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
//        
//        settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
//        settingsPopoverController.delegate = self;
//        settingsPopoverController.passthroughViews = @[btn];
//        settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
//        settingsPopoverController.wantsDefaultContentAppearance = NO;
//        NSMutableArray* buttons = [[NSMutableArray alloc] init];
//        for (UIControl* btn in self.navigationController.navigationBar.subviews)
//            if ([btn isKindOfClass:[UIControl class]])
//                [buttons addObject:btn];
//        UIView* view = [buttons objectAtIndex:0];
//        
//        [settingsPopoverController presentPopoverFromRect:[view convertRect:view.bounds toView:nil]
//                                                   inView:btn
//                                 permittedArrowDirections:WYPopoverArrowDirectionAny
//                                                 animated:YES
//                                                  options:WYPopoverAnimationOptionFadeWithScale];
//
//    
//    } else {
//        [self close:nil];
//    }
    
}

- (void)close:(id)sender
{
    [settingsPopoverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:settingsPopoverController];
    }];
}

- (void)change:(id)sender
{
    // Change popover content size
    
    //[settingsPopoverController setPopoverContentSize:CGSizeMake(320, 480)];
    
    // Change complete theme
    
    //settingsPopoverController.theme = [WYPopoverTheme themeForIOS6];
    
    //
    
    [settingsPopoverController beginThemeUpdates];
    settingsPopoverController.theme.arrowHeight = 13;
    settingsPopoverController.theme.arrowBase = 25;
    [settingsPopoverController endThemeUpdates];
}

-(void)seletedSorterField:(NSString *)sorterField
{
    
}

@end
