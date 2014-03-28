//
//  NewItemViewController.h
//  myInventory
//
//  Created by amar tk on 22/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InventoryItem;

@protocol NewItemDelegate <NSObject>

-(void)newItemAdded:(InventoryItem *) inventoryItem;
-(void)addItemCancelled;

@end

@interface NewItemViewController : UIViewController

@property(nonatomic, weak) id<NewItemDelegate> delegate;

-(IBAction)addNewItem:(id)sender;
-(IBAction)addCancelled:(id)sender;

@end
