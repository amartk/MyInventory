//
//  InventoryCategory.h
//  myInventory
//
//  Created by amar tk on 04/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InventoryCategory : NSObject <NSCopying>

@property(nonatomic, strong) NSString *name, *imageName, *description;
@property(nonatomic) NSInteger categoryId;

@end
