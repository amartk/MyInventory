//
//  AssetTableViewCell.h
//  myInventory
//
//  Created by amar tk on 20/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *nameLabel, *totalValueLabel, *multiplierLabel;
@property(nonatomic, weak) IBOutlet UIImageView *itemImage;

@end
