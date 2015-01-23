//
//  User+FollowApi.h
//  Quick
//
//  Created by hello on 15-1-23.
//  Copyright (c) 2015年 hellomaya. All rights reserved.
//

#import "User.h"

@interface User (FollowApi)

- (BOOL)follow:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)unfollow:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)getFollowers:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)getFollowings:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray Complete:(void (^)(NSInteger status, NSString *message))complete;

@end
