//
//  UtilityManager.h
//  myInventory
//
//  Created by amar tk on 27/03/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityManager : NSObject

+(id)sharedUtilityManager;
/**
 copy the database from the app bundle to documents directory
 */
-(void)copyDatabase;

@end
