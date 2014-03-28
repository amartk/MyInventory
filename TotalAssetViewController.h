//
//  TotalAssetViewController.h
//  myInventory
//
//  Created by amar tk on 20/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortPickerViewController.h"

@interface TotalAssetViewController : UITableViewController <SorterPickerDelegate>

@property(nonatomic, strong) UIPopoverController *sorterPickerPopOver;
@property(nonatomic, strong) SortPickerViewController *sorterPickerViewController;

-(IBAction)chooseSortFieldTapped:(id)sender;

@end
