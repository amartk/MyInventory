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
        NSString *query = [NSString stringWithFormat:@"INSERT INTO mi_items(name, category, quantity, price, imageName, purchaseDate, location, vendor, notes, warrantyDate, tag) values('%@', '%d', %ld, %f, '%@', '%@', '%@', '%@', '%@', '%@', '%@')", inventoryItem.name, inventoryItem.categoryId, (long)inventoryItem.quantity, inventoryItem.price, inventoryItem.imageName, inventoryItem.purchaseDate, inventoryItem.location, inventoryItem.vendor, inventoryItem.notes, inventoryItem.warrantyDate, inventoryItem.tag];
        if (![database executeUpdate:query]) {
            NSLog(@"Failed to insert into mi_items");
        }
        
        
       itemId = (NSInteger)[database lastInsertRowId];
        
        [database close];
    }
    
    return itemId;
}

-(NSMutableArray *)getAllItems
{
    NSMutableArray *inventoryTtems = [[NSMutableArray alloc] init];
    
    if ([database open]) {
        
        NSString *query = [NSString stringWithFormat:@"SELECT mi_items.*, mi_category.name AS categoryName FROM mi_items LEFT JOIN mi_category WHERE mi_items.category = mi_category.id"];
        FMResultSet *resultSet = [database executeQuery:query];
        InventoryItem *inventoryItem = [[InventoryItem alloc] init];
        
        while ([resultSet next]) {
            
            inventoryItem.itemId = [resultSet intForColumn:@"id"];
            inventoryItem.name = [resultSet stringForColumn:@"name"];
            inventoryItem.categoryName = [resultSet stringForColumn:@"categoryName"];
            inventoryItem.quantity = [resultSet intForColumn:@"quantity"];
            inventoryItem.price = [resultSet doubleForColumn:@"price"];
            inventoryItem.imageName = [resultSet stringForColumn:@"imageName"];
            inventoryItem.purchaseDate = [resultSet dateForColumn:@"purchaseDate"];
            inventoryItem.location = [resultSet stringForColumn:@"location"];
            inventoryItem.vendor = [resultSet stringForColumn:@"vendor"];
            inventoryItem.notes = [resultSet stringForColumn:@"notes"];
            inventoryItem.warrantyDate = [resultSet dateForColumn:@"warrantyDate"];
            inventoryItem.tag = [resultSet stringForColumn:@"tag"];
            
            [inventoryTtems addObject:[inventoryItem copy]];
        }
        
        [database close];
    }

    return inventoryTtems;
}

-(void)deleteItemWithId:(NSInteger)itemId
{
    if ([database open]) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM mi_items where id = %d", itemId];
        if (![database executeUpdate:query]) {
            NSLog(@"Failed to delete item with id %d", itemId);
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
        NSString *query = [NSString stringWithFormat:@"UPDATE mi_items SET category = 1 where category = %d", categoryId];
        if (![database executeUpdate:query]) {
            NSLog(@"Failed to update category to general");
        } else {
            query = [NSString stringWithFormat:@"DELETE FROM mi_category where id = %d", categoryId];
            if (![database executeUpdate:query]) {
                NSLog(@"Failed to delete category with id %d", categoryId);
            }

        }
        
        [database close];
    }
}


@end
