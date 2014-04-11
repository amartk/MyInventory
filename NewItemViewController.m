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
    inventoryItem.name = @"head set";
    inventoryItem.categoryId = 4;
    inventoryItem.quantity = 3;
    inventoryItem.price = 1200.0f;
    inventoryItem.imageName = @"object.png";
    
    inventoryItem.location = @"mylapore";
    inventoryItem.vendor = @"jabong";
    inventoryItem.purchaseDate = [NSDate date];
    inventoryItem.warrantyDate = [NSDate date];
    inventoryItem.tag = @"simple tag ";
    inventoryItem.notes = @"This is a simple note for this item";
    [_delegate newItemAdded:inventoryItem];
}

-(void)addCancelled:(id)sender
{
    [_delegate addItemCancelled];
}


@end
