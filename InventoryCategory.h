//
//  InventoryCategory.h
//  myInventory
//
//  Created by amar tk on 04/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InventoryCategory : NSObject <NSCoding>

-(id) initWithName:(NSString *)name withImage:(UIImage *)image;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *image;

@end
