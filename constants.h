//
//  constants.h
//  myInventory
//
//  Created by amar tk on 06/01/14.
//  Copyright (c) 2014 zoomrx. All rights reserved.
//

#ifndef myInventory_constants_h
#define myInventory_constants_h

#define CATEGORY_FILE       @"categoryFile"
#define ITEMS_FILE          @"itemsFile"

#define APPLICATION_DOC_DIRECTORY   [NSString stringWithFormat:@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]]
#define DATABASE_NAME               @"myInventory.sqlite"

#define IS_IOS_7_OR_LATER                           ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#endif
