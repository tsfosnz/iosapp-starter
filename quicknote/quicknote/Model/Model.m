//
//  Model.m
//  RITraining
//
//  Created by hello on 14-1-26.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "Model.h"

@implementation Model

- (id) init
{
    self = [super init];
    if (self) {
        self.cache = [DiskCache getInstance];
        self.config = [AppConfig getInstance];
        
        if (!self.db) {
            self.db = [FMDatabase databaseWithPath:self.config.dbPath];
        }
        
        if (![self.db open]) {
            self.db = nil;
        }
    }
    return self;
    
}

// remove nil,

- (NSString *)escape:(NSString *)string
{
    if (string == nil || (NSNull *)string == [NSNull null] || string == NULL) {
        string = @"";
    }
    
    [string stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
    return [NSString stringWithFormat:@"'%@'", string];
    
}

@end
