//
//  DBManager.m
//  myInventory
//
//  Created by amar tk on 27/03/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "DBManager.h"

@interface DBManager ()
{
    FMDatabase *database;
}
@end

@implementation DBManager


-(id)init
{
    self = [super init];
    if (self) {
        NSString *dBPath = [NSString stringWithFormat:@"%@/%@", APPLICATION_DOC_DIRECTORY, DATABASE_NAME];
        database = [FMDatabase databaseWithPath:dBPath];
    }
    
    return self;
}

-(NSInteger)insertIntoItemsTable:(InventoryItem *)inventoryItem
{
    NSInteger itemId = 0;
    if ([database open]) {
        NSString *query = [NSString stringWithFormat:@"INSERT INTO mi_items(name, category, quantity, price, imageName, purchaseDate, location, vendor, notes, warrantyDate, tag) values('%@', '%d', %d, %f, '%@', '%@', '%@', '%@', '%@', '%@', '%@')", inventoryItem.name, (int)inventoryItem.categoryId, (int)inventoryItem.quantity, inventoryItem.price, inventoryItem.imageName, inventoryItem.purchaseDate, inventoryItem.location, inventoryItem.vendor, inventoryItem.notes, inventoryItem.warrantyDate, inventoryItem.tag];
        if (![database executeUpdate:query]) {
            NSLog(@"Failed to insert into mi_items");
        }
        
        
       itemId = (NSInteger)[database lastInsertRowId];
        
        [database close];
    }
    
    return itemId;
}

-(NSMutableDictionary *)getAllItems
{
    NSMutableDictionary *inventoryItems = [[NSMutableDictionary alloc] init];
    if ([database open]) {
        [inventoryItems setObject:[[NSMutableDictionary alloc] init] forKey:@"ITEMS_LIST"];
        NSString *query = [NSString stringWithFormat:@"SELECT mi_items.*, mi_category.name AS categoryName FROM mi_items LEFT JOIN mi_category WHERE mi_items.category = mi_category.id ORDER BY mi_items.name"];
        FMResultSet *resultSet = [database executeQuery:query];
        InventoryItem *inventoryItem = [[InventoryItem alloc] init];
        float totalValue = 0.0;
        while ([resultSet next]) {
            
            inventoryItem.itemId = [resultSet intForColumn:@"id"];
            inventoryItem.name = [resultSet stringForColumn:@"name"];
            inventoryItem.categoryName = [resultSet stringForColumn:@"categoryName"];
            inventoryItem.quantity = [resultSet intForColumn:@"quantity"];
            inventoryItem.price = [resultSet doubleForColumn:@"price"];
            inventoryItem.imageName = [resultSet stringForColumn:@"imageName"];
            inventoryItem.purchaseDate = [resultSet stringForColumn:@"purchaseDate"];
            inventoryItem.location = [resultSet stringForColumn:@"location"];
            inventoryItem.vendor = [resultSet stringForColumn:@"vendor"];
            inventoryItem.notes = [resultSet stringForColumn:@"notes"];
            inventoryItem.warrantyDate = [resultSet stringForColumn:@"warrantyDate"];
            inventoryItem.tag = [resultSet stringForColumn:@"tag"];
            
            totalValue += inventoryItem.quantity * inventoryItem.price;
            
            NSString *firstLetter = [inventoryItem.name substringToIndex:1];
            
            BOOL present = NO;
            
            for (NSString *key in [[inventoryItems objectForKey:@"ITEMS_LIST"] allKeys]) {
                if ([key isEqualToString:firstLetter]) {
                    present = YES;
                    break;
                }
            }
            
            if (!present) {
                [[inventoryItems objectForKey:@"ITEMS_LIST"] setObject:[[NSMutableArray alloc] init] forKey:firstLetter];
            }
            
            [[[inventoryItems objectForKey:@"ITEMS_LIST"] objectForKey:firstLetter] addObject:[inventoryItem copy]];
        }
        
        [inventoryItems setObject:[NSNumber numberWithFloat:totalValue] forKey:@"TOTAL_VALUE"];
        
        [database close];
    }
    
    return inventoryItems;
}

-(NSMutableDictionary *)getAllItemsWithCategory:(NSInteger)categoryId
{
    NSMutableDictionary *inventoryItems = [[NSMutableDictionary alloc] init];
    if ([database open]) {
        
//        NSString *query = [NSString stringWithFormat:@"SELECT mi_items.*, mi_category.name AS categoryName FROM mi_items LEFT JOIN mi_category WHERE mi_items.category = mi_category.id ORDER BY mi_items.name"];
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM mi_items WHERE category = %d ORDER BY name", (int)categoryId];
        FMResultSet *resultSet = [database executeQuery:query];
        
        InventoryItem *inventoryItem = [[InventoryItem alloc] init];
        
        while ([resultSet next]) {
            
            inventoryItem.itemId = [resultSet intForColumn:@"id"];
            inventoryItem.name = [resultSet stringForColumn:@"name"];
            inventoryItem.quantity = [resultSet intForColumn:@"quantity"];
            inventoryItem.price = [resultSet doubleForColumn:@"price"];
            inventoryItem.imageName = [resultSet stringForColumn:@"imageName"];
            inventoryItem.purchaseDate = [resultSet stringForColumn:@"purchaseDate"];
            inventoryItem.location = [resultSet stringForColumn:@"location"];
            inventoryItem.vendor = [resultSet stringForColumn:@"vendor"];
            inventoryItem.notes = [resultSet stringForColumn:@"notes"];
            inventoryItem.warrantyDate = [resultSet stringForColumn:@"warrantyDate"];
            inventoryItem.tag = [resultSet stringForColumn:@"tag"];
            
            
            NSString *firstLetter = [inventoryItem.name substringToIndex:1];
            
            BOOL present = NO;
            
            for (NSString *key in [inventoryItems allKeys]) {
                if ([key isEqualToString:firstLetter]) {
                    present = YES;
                    break;
                }
            }
            
            if (!present) {
                [inventoryItems setObject:[[NSMutableArray alloc] init] forKey:firstLetter];
            }
            
            [[inventoryItems objectForKey:firstLetter] addObject:[inventoryItem copy]];
        }
        
        [database close];
    }
    
    return inventoryItems;
}



-(void)deleteItemWithId:(NSInteger)itemId
{
    if ([database open]) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM mi_items where id = %d", (int)itemId];
        if (![database executeUpdate:query]) {
            NSLog(@"Failed to delete item with id %d", (int)itemId);
        }
        
        [database close];
    }
}

-(NSInteger)insertIntoCategoryTable:(InventoryCategory *)inventoryCategory
{
    NSInteger categoryId = 0;
    
    if ([database open]) {
        NSString *query = [NSString stringWithFormat:@"INSERT INTO mi_category(name, imageName, description) values('%@', '%@', '%@')", inventoryCategory.name, inventoryCategory.imageName,  inventoryCategory.description];
        if (![database executeUpdate:query]) {
            NSLog(@"Failed to insert into mi_category");
        }
        
        
        categoryId = (NSInteger)[database lastInsertRowId];
        
        [database close];
    }
    return categoryId;
}

-(NSMutableArray *)getAllCategories
{
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    if ([database open]) {
        
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM mi_category"];
        FMResultSet *resultSet = [database executeQuery:query];
        InventoryCategory *inventoryCategory = [[InventoryCategory alloc] init];
        
        while ([resultSet next]) {
            
            inventoryCategory.categoryId = [resultSet intForColumn:@"id"];
            inventoryCategory.name = [resultSet stringForColumn:@"name"];
            inventoryCategory.imageName = [resultSet stringForColumn:@"imageName"];
            inventoryCategory.description = [resultSet stringForColumn:@"description"];
            
            [categories addObject:[inventoryCategory copy]];
        }
        
        [database close];
    }
    return categories;
}

-(void)deleteCategoryWithId:(NSInteger)categoryId
{
    if ([database open]) {
        NSString *query = [NSString stringWithFormat:@"UPDATE mi_items SET category = 1 where category = %d", (int)categoryId];
        if (![database executeUpdate:query]) {
            NSLog(@"Failed to update category to general");
        } else {
            query = [NSString stringWithFormat:@"DELETE FROM mi_category where id = %d", (int)categoryId];
            if (![database executeUpdate:query]) {
                NSLog(@"Failed to delete category with id %d", (int)categoryId);
            }

        }
        [database close];
    }
}

-(void)updateCategoryDescriptionTo:(NSString *)categoryDesc forCategory:(NSInteger)categoryId
{
    if ([database open]) {
        NSString *query = [NSString stringWithFormat:@"UPDATE mi_category SET description = '%@' where id = %d", categoryDesc, (int)categoryId];\
        NSLog(@"%@", query);
        if (![database executeUpdate:query]) {
            NSLog(@"Failed to update category description");
        }
        [database close];
    }
}

-(NSMutableDictionary *)getCountOfItemsInEachCategory
{
    NSMutableDictionary *countOfItems = [[NSMutableDictionary alloc] init];
    
    if ([database open]) {
        
        NSString *query = [NSString stringWithFormat:@"SELECT category, count(*) as count FROM mi_items group by category"];
        FMResultSet *resultSet = [database executeQuery:query];
        
        while ([resultSet next]) {
            [countOfItems setObject:[NSNumber numberWithInteger:[resultSet intForColumn:@"count"]] forKey:[NSNumber numberWithInteger:[resultSet intForColumn:@"category"]]];
            
        }
        
        [database close];
    }
    return countOfItems;
}

-(NSMutableDictionary *)getCountOfItemsInEachVendor
{
    NSMutableDictionary *countOfItems = [[NSMutableDictionary alloc] init];
    
    if ([database open]) {
        
        NSString *query = [NSString stringWithFormat:@"SELECT vendor, count(*) as count FROM mi_items group by vendor order by vendor"];
        FMResultSet *resultSet = [database executeQuery:query];
        
        while ([resultSet next]) {
            [countOfItems setObject:[NSNumber numberWithInteger:[resultSet intForColumn:@"count"]] forKey:[resultSet stringForColumn:@"vendor"]];
            
        }
        
        [database close];
    }
    return countOfItems;
}

-(NSMutableDictionary *)getCountOfItemsInEachLocation
{
    NSMutableDictionary *countOfItems = [[NSMutableDictionary alloc] init];
    
    if ([database open]) {
        
        NSString *query = [NSString stringWithFormat:@"SELECT location, count(*) as count FROM mi_items group by location order by location"];
        FMResultSet *resultSet = [database executeQuery:query];
        
        while ([resultSet next]) {
            [countOfItems setObject:[NSNumber numberWithInteger:[resultSet intForColumn:@"count"]] forKey:[resultSet stringForColumn:@"location"]];
            
        }
        
        [database close];
    }
    return countOfItems;
}

-(NSMutableArray *)getItemsSortedByWarrantyDate
{
    NSMutableArray *inventoryItems = [[NSMutableArray alloc] init];
    if ([database open]) {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM mi_items ORDER BY warrantyDate"];
        FMResultSet *resultSet = [database executeQuery:query];
        InventoryItem *inventoryItem = [[InventoryItem alloc] init];
        while ([resultSet next]) {
            
            inventoryItem.itemId = [resultSet intForColumn:@"id"];
            inventoryItem.name = [resultSet stringForColumn:@"name"];
            inventoryItem.quantity = [resultSet intForColumn:@"quantity"];
            inventoryItem.price = [resultSet doubleForColumn:@"price"];
            inventoryItem.imageName = [resultSet stringForColumn:@"imageName"];
            inventoryItem.purchaseDate = [resultSet stringForColumn:@"purchaseDate"];
            inventoryItem.location = [resultSet stringForColumn:@"location"];
            inventoryItem.vendor = [resultSet stringForColumn:@"vendor"];
            inventoryItem.notes = [resultSet stringForColumn:@"notes"];
            inventoryItem.warrantyDate = [resultSet stringForColumn:@"warrantyDate"];
            inventoryItem.tag = [resultSet stringForColumn:@"tag"];
            
            [inventoryItems addObject:[inventoryItem copy]];
        }
        
        
        [database close];
    }
    
    return inventoryItems;
}


@end
