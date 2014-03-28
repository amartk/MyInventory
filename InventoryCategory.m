//
//  InventoryCategory.m
//  myInventory
//
//  Created by amar tk on 04/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "InventoryCategory.h"

@implementation InventoryCategory

-(id)copyWithZone:(NSZone *)zone
{
    InventoryCategory *inventoryCategory = [[InventoryCategory alloc] init];
    
    if (inventoryCategory != nil) {
        
        [inventoryCategory setCategoryId:_categoryId];
        [inventoryCategory setName:[_name copyWithZone:zone]];
        [inventoryCategory setImageName:[_imageName copyWithZone:zone]];
        [inventoryCategory setDescription:[_description copyWithZone:zone]];
    }
    
    return inventoryCategory;
}



@end
