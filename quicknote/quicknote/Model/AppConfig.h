//
//  AppConfig.h
//
//  Created by  
//  Copyright (c) 2013-2014 
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppConfig : NSObject

@property (atomic, assign) int screenWidth;
@property (atomic, assign) int screenHeight;
@property (atomic, assign) NSInteger contactIsImported;
@property (atomic, assign) NSInteger userIsLogin;
@property (atomic, assign) NSInteger groupExists;

@property (atomic, assign) BOOL disableAlert;

@property (atomic, retain) NSString *dbPath;

// we have supported mutli-users, also switch data by them
@property (atomic, retain) NSMutableArray *userArray;

+ (id)getInstance;

@end
