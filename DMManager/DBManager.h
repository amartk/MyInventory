//
//  DBManager.h
//  myInventory
//
//  Created by amar tk on 27/03/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "InventoryItem.h"
#import "InventoryCategory.h"

@interface DBManager : NSObject

-(NSInteger)insertIntoItemsTable:(InventoryItem *)inventoryItem;
-(NSMutableArray *)getAllItems;
-(void)deleteItemWithId:(NSInteger)itemId;

-(NSInteger)insertIntoCategoryTable:(InventoryCategory *)inventoryCategory;
-(NSMutableArray *)getAllCategories;
-(void)deleteCategoryWithId:(NSInteger)categoryId;

@end
