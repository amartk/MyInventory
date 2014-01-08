//
//  CategoryViewController.h
//  myInventory
//
//  Created by amar tk on 02/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCategoryViewController.h"
#import "CategoryDetailsViewController.h"

@interface CategoryViewController : UITableViewController <NewCategoryViewControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, CategoryDetailsViewControllerDelegate>

@end
