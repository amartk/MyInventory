//
//  InventoryCategory.m
//  myInventory
//
//  Created by amar tk on 04/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "InventoryCategory.h"

@implementation InventoryCategory

@synthesize name, image;

-(id)initWithName:(NSString *)mName withImage:(UIImage *)mImage
{
    if (self = [super init]) {
        self.name = mName;
        self.image = mImage;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"CLASS_NAME"];
        self.image = [aDecoder decodeObjectForKey:@"CLASS_IMAGE"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name forKey:@"CLASS_NAME"];
    [aCoder encodeObject:image forKey:@"CLASS_IMAGE"];
}

@end
