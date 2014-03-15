//
//  Model.h
//  RITraining
//
//  Created by hello on 14-1-26.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "AppConfig.h"
#import "DiskCache.h"

@interface Model : NSObject

@property (atomic, retain) FMDatabase *db;
@property (atomic, retain) AppConfig *config;
@property (atomic, retain) DiskCache *cache;

- (NSString *)escape:(NSString *)string;

@end
