//
//  NewItemViewController.m
//  myInventory
//
//  Created by amar tk on 22/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "NewItemViewController.h"
#import "InventoryItem.h"

@interface NewItemViewController ()

@end

@implementation NewItemViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNewItem:(id)sender
{
    InventoryItem *inventoryItem = [[InventoryItem alloc] init];
    inventoryItem.name = @"da vinci code";
    inventoryItem.categoryId = 2;
    inventoryItem.quantity = 1;
    inventoryItem.price = 200.0f;
    inventoryItem.imageName = @"object.png";
    
    inventoryItem.location = @"tambram";
    inventoryItem.vendor = @"landmark";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    inventoryItem.purchaseDate = [dateFormatter stringFromDate:[NSDate date]];
    inventoryItem.warrantyDate = @"23/04/2014";
    inventoryItem.tag = @"simple tag ";
    inventoryItem.notes = @"This is a simple note for this item";
    [_delegate newItemAdded:inventoryItem];
}

-(void)addCancelled:(id)sender
{
    [_delegate addItemCancelled];
}


@end
