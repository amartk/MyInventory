//
//  ItemsCell.h
//  myInventory
//
//  Created by amar tk on 08/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *itemImage;
@property(nonatomic, weak) IBOutlet UILabel *itemName;

@end
