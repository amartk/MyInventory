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
-(NSMutableDictionary *)getAllItems;
-(NSMutableDictionary *)getAllItemsWithCategory:(NSInteger)categoryId;
-(void)deleteItemWithId:(NSInteger)itemId;

-(NSInteger)insertIntoCategoryTable:(InventoryCategory *)inventoryCategory;
-(NSMutableArray *)getAllCategories;
-(void)deleteCategoryWithId:(NSInteger)categoryId;
-(NSMutableDictionary *)getCountOfItemsInEachCategory;
-(NSMutableDictionary *)getCountOfItemsInEachVendor;

-(void)updateCategoryDescriptionTo:(NSString *)categoryDesc forCategory:(NSInteger)categoryId;
@end
