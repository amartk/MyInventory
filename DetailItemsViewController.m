//
//  DetailItemsViewController.m
//  myInventory
//
//  Created by amar tk on 25/03/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "DetailItemsViewController.h"

@interface DetailItemsViewController ()

@end

@implementation DetailItemsViewController

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

-(void)deleteItem:(id)sender
{
    [_delegate deleteItemWithId:_inventoryItem.itemId];
}
@end
