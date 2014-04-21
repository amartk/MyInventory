//
//  InventoryItem.h
//  myInventory
//
//  Created by amar tk on 08/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InventoryItem : NSObject<NSCopying>

@property(nonatomic, strong) NSString *name, *vendor, *location, *notes, *imageName, *tag, *categoryName;
@property(nonatomic, strong) NSString *purchaseDate, *warrantyDate;
@property(nonatomic) NSInteger itemId, quantity, categoryId;
@property(nonatomic) float price;

-(id)initWithName:(NSString *)mName withImage:(NSString *)mImageName;

@end
