//
//  User+UserApi.h
//  All api network access implementation of /user/*
//
//  Created by hello on 14-8-28.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "User.h"

@interface User (UserApi)

// authentication

- (BOOL)login:(NSDictionary *)values
     Complete:(void (^)(NSInteger status, NSString *message))complete;
- (BOOL)logout;

- (BOOL)block:(NSDictionary *)values
     Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)search:(NSDictionary *)values ResultArray:(NSMutableArray *)userArray
      Complete:(void (^)(NSInteger status, NSString *message))complete;

// notification
- (BOOL)getLatestUpdate:(NSDictionary *)updateDictionary
               Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)markItRead:(NSDictionary *)values
          Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)registerDevToken:(NSDictionary *)values
                Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)enableAPN:(NSDictionary *)values
         Complete:(void (^)(NSInteger status, NSString *message))complete;

@end
