//
//  CategoryDetailsViewController.h
//  myInventory
//
//  Created by amar tk on 08/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryCategory.h"

@protocol CategoryDetailsViewControllerDelegate <NSObject>

-(void)deleteCategoryWithId:(NSInteger) categoryId;

@end

@interface CategoryDetailsViewController : UIViewController

@property(nonatomic) NSInteger categoryId;
@property(nonatomic, strong) InventoryCategory *category;
@property(nonatomic, weak) id<CategoryDetailsViewControllerDelegate> delegate;

- (IBAction)deleteCategory:(id)sender;

@end
