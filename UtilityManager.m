//
//  UtilityManager.m
//  myInventory
//
//  Created by amar tk on 27/03/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import "UtilityManager.h"

@implementation UtilityManager

+(id)sharedUtilityManager
{
    static UtilityManager *utilityManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utilityManager = [[UtilityManager alloc] init];
    });
    
    return utilityManager;
}

-(void)copyDatabase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
//    NSString *bundleDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/myInventory.sqlite"];
    NSString *bundleDBPath = [[NSBundle mainBundle] pathForResource:@"myInventory" ofType:@"sqlite"];
    NSString *docDBPath = [NSString stringWithFormat:@"%@/%@", APPLICATION_DOC_DIRECTORY, DATABASE_NAME];
    
    if (![fileManager fileExistsAtPath:docDBPath]) {
        NSError *error;
        if (![fileManager copyItemAtPath:bundleDBPath toPath:docDBPath error:&error]) {
            NSLog(@"not able to copy db %@", error);
        }
    }
    
}
@end
