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

- (BOOL)login:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)logout;

// fetching images by user_uuid

- (BOOL)getImages:(NSMutableArray *)imageArray Parameters:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)removeImage:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)excludeImage:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

// follower & following

- (BOOL)follow:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)unfollow:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)getFollowers:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)getFollowings:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray Complete:(void (^)(NSInteger status, NSString *message))complete;

// block a user
// search a user

- (BOOL)block:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)search:(NSDictionary *)values ResultArray:(NSMutableArray *)userArray Complete:(void (^)(NSInteger status, NSString *message))complete;

// notification
- (BOOL)getLatestUpdate:(NSDictionary *)updateDictionary Complete:(void (^)(NSInteger status, NSString *message))complete;
- (BOOL)markItRead:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

// remote notificaiton
- (BOOL)registerDevToken:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)enableAPN:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

@end
