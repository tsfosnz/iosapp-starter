//
//  User+ImageApi.h
//  Quick
//
//  Created by hello on 15-1-23.
//  Copyright (c) 2015年 hellomaya. All rights reserved.
//

#import "User.h"

@interface User (ImageApi)

- (BOOL)getImages:(NSMutableArray *)imageArray Parameters:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
- (BOOL)removeImage:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
- (BOOL)excludeImage:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;

@end
