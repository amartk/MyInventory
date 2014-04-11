//
//  TotalAssetViewController.h
//  myInventory
//
//  Created by amar tk on 20/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalAssetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UITableView *splitterTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalWorthLabel;

-(IBAction)chooseSortFieldTapped:(id)sender;

@end
