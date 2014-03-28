//
//  DetailItemsViewController.h
//  myInventory
//
//  Created by amar tk on 25/03/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryItem.h"

@protocol DetailItemsDelegate <NSObject>

-(void)deleteItemWithId:(NSInteger)itemId;

@end

@interface DetailItemsViewController : UIViewController
@property(nonatomic, strong) InventoryItem *inventoryItem;
@property(nonatomic, weak) id<DetailItemsDelegate>delegate;

-(IBAction)deleteItem:(id)sender;
@end
