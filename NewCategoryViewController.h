//
//  NewCategoryViewController.h
//  myInventory
//
//  Created by amar tk on 06/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InventoryCategory;
@class NewCategoryViewController;
@protocol NewCategoryViewControllerDelegate <NSObject>

-(void) didAddCategory:(InventoryCategory *)category;
-(void) didCancel;

@end

@interface NewCategoryViewController : UITableViewController

@property(nonatomic, weak) IBOutlet UITextField *categoryName;
@property(nonatomic, weak) id<NewCategoryViewControllerDelegate> delegate;

- (IBAction)cancelAdd:(id)sender;
- (IBAction)addCategory:(id)sender;
@end
