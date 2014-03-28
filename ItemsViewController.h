//
//  ItemsViewController.h
//  myInventory
//
//  Created by amar tk on 02/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewItemViewController.h"
#import "DetailItemsViewController.h"
@interface ItemsViewController : UITableViewController <NewItemDelegate, DetailItemsDelegate>

@end
