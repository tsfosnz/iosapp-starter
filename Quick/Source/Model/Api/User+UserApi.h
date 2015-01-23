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
      success:(void (^)(NSString *message))success
      failure:(void (^)(NSString *message))failure;
- (BOOL)logout;

// fetching images by user_uuid

- (BOOL)getImages:(NSMutableArray *)imageArray Parameters:(NSDictionary *)values;
- (BOOL)removeImage:(NSDictionary *)values;
- (BOOL)excludeImage:(NSDictionary *)values;

// follower & following

- (BOOL)follow:(NSDictionary *)values;
- (BOOL)unfollow:(NSDictionary *)values;
- (BOOL)getFollowers:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray;
- (BOOL)getFollowings:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray;

// block a user
// search a user

- (BOOL)block:(NSDictionary *)values
      success:(void (^)(NSString *message))success
      failure:(void (^)(NSString *message))failure;

- (BOOL)search:(NSDictionary *)values ResultArray:(NSMutableArray *)userArray;

// notification
- (BOOL)getLatestUpdate:(NSDictionary *)updateDictionary;
- (BOOL)markItRead:(NSDictionary *)values;

// remote notificaiton
- (BOOL)registerDevToken:(NSDictionary *)values;
- (BOOL)enableAPN:(NSDictionary *)values;

@end
