//
//  NewCategoryViewController.m
//  myInventory
//
//  Created by amar tk on 06/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "NewCategoryViewController.h"
#import "InventoryCategory.h"

@interface NewCategoryViewController ()

@end

@implementation NewCategoryViewController

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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (IBAction)cancelAdd:(id)sender {
    [self.delegate didCancel];
}

- (IBAction)addCategory:(id)sender {

    InventoryCategory *inventoryCategory = [[InventoryCategory alloc] init];
    inventoryCategory.name = @"myNew Category";
    inventoryCategory.imageName = @"object.png";
    
    [self.delegate didAddCategory:inventoryCategory];

}
@end
