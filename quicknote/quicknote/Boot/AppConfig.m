//
//  AppConfig.m
//  test
//
//  Created by  
//  Copyright (c) 2013-2014 
//

#import "AppConfig.h"

@implementation AppConfig

+ (id)getInstance {
    static AppConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.userArray = [[NSMutableArray alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
            }
    return self;
}



- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
