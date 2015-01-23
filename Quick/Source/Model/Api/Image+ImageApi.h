//
//  Image+ImageApi.h
//  Gaje
//
//  Created by hello on 14-9-7.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Image.h"

@interface Image (ImageApi)

- (BOOL)getLatest:(NSMutableArray*)imageArray Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)upload:(NSDictionary *)values ProgressBar:(UIProgressView *)progressBar Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)addComment:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
- (BOOL)getComments:(NSMutableArray *)commentArray Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)addBrand:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
- (BOOL)getBrands:(NSMutableArray *)branderArray Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)getTopBrands:(NSMutableArray *)imageArray Complete:(void (^)(NSInteger status, NSString *message))complete;

@end
