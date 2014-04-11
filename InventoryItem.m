//
//  InventoryItem.m
//  myInventory
//
//  Created by amar tk on 08/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "InventoryItem.h"

@implementation InventoryItem


-(id)initWithName:(NSString *)mName withImage:(NSString *)mImageName
{
    if (self = [super init]) {
        _name = mName;
        _imageName = mImageName;
        _categoryId = 0;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    InventoryItem *inventoryItem = [[InventoryItem alloc] init];
    
    if (inventoryItem != nil) {
       
        [inventoryItem setItemId:_itemId];
        [inventoryItem setName:[_name copyWithZone:zone]];
        [inventoryItem setVendor:[_vendor copyWithZone:zone]];
        [inventoryItem setLocation:[_location copyWithZone:zone]];
        [inventoryItem setCategoryId:_categoryId];
        [inventoryItem setQuantity:_quantity];
        [inventoryItem setCategoryName:[_categoryName copyWithZone:zone]];
        [inventoryItem setNotes:[_notes copyWithZone:zone]];
        [inventoryItem setImageName:[_imageName copyWithZone:zone]];
        [inventoryItem setTag:[_tag copyWithZone:zone]];
        [inventoryItem setPurchaseDate:[_purchaseDate copyWithZone:zone]];
        [inventoryItem setWarrantyDate:[_warrantyDate copyWithZone:zone]];
        [inventoryItem setPrice:_price];
    }
    
    return inventoryItem;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"ITEM_NAME"];
        _imageName = [aDecoder decodeObjectForKey:@"ITEM_IMAGE"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"ITEM_NAME"];
    [aCoder encodeObject:_imageName forKey:@"ITEM_IMAGE"];
}

@end
