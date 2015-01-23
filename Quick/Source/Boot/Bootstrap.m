//
//  Bootstrap.m
//  RITraining
//
//  Created by  on 14-1-8.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "Bootstrap.h"
#import "User.h"
#import "BackgroundTask.h"

@implementation Bootstrap

+ (id)getInstance {
    static Bootstrap *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.config = [AppConfig getInstance];
        instance.cache = [DiskCache getInstance];
    });
    return instance;
}

- (void)bootstrap {
    [self initdb];
    [self initScreenSize];
    [self initDiskCache];
    [self initAuth];
    [self initBackgroundTask];
}

- (void)initdb {
    // copy db
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSError *error = nil;
    
    NSString *databasePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"local.sqlite"];
    NSString *toPath = [NSString stringWithFormat:@"%@/%@", document, @"local.sqlite" ];
    
    //// NSLog(@"data = %@", databasePath);
    
    self.config.dbPath = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
            [[NSFileManager defaultManager] copyItemAtPath:databasePath
                                                    toPath:toPath
                                                     error:&error];
        }
        
        if (error == nil) {
            
            self.config.dbPath = toPath;
            
            FMDatabase *db = [FMDatabase databaseWithPath:toPath];
            
            if ([db open]) {
                FMResultSet *s;
                NSString *value;
                
                s = nil;
                s = [db executeQuery:@"SELECT value FROM setting WHERE name='user_is_login'"];
                while ([s next]) {
                    //retrieve values for each record
                    value = [s stringForColumn:@"value"];
                    if ([value isEqualToString:@"1"]) {
                        self.config.userIsLogin = 1;
                    } else {
                        self.config.userIsLogin = 0;
                    }
                }
                
                [db close];
            }
        }
    }
}

- (void)initScreenSize
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.config.screenWidth =  (int) roundf(screenRect.size.width);
    self.config.screenHeight = (int) roundf(screenRect.size.height);
}

- (void)initDiskCache
{
    [[DiskCache getInstance] initCache];
}

- (void)initAuth
{
    
    User *user = [User getInstance];
    AppConfig *config = [AppConfig getInstance];
    
    if ([user exits]) {
        config.userIsLogin = 1;
        config.token = user.token;
        return;
    }
    
    config.userIsLogin = 0;
    config.token = @"";
    
}

- (void)initBackgroundTask
{
    BackgroundTask *task = [BackgroundTask getInstance];
    [task initTask];
    
    
    
}


@end
