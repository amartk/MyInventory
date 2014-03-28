//
//  SortPickerViewController.h
//  myInventory
//
//  Created by amar tk on 22/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SorterPickerDelegate <NSObject>

-(void)seletedSorterField:(NSString *) sorterField;

@end

@interface SortPickerViewController : UITableViewController

@property(nonatomic, strong) NSMutableArray *sorterNames;
@property(nonatomic, weak) id<SorterPickerDelegate> delegate;

@end
