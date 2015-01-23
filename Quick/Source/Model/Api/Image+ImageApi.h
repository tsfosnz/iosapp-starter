//
//  Image+ImageApi.h
//  Gaje
//
//  Created by hello on 14-9-7.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Image.h"

@interface Image (ImageApi)

- (BOOL)getLatest:(NSMutableArray*)imageArray
          success:(void (^)(NSString *message))success
          failure:(void (^)(NSString *message))failure;

- (BOOL)upload:(NSDictionary *)values ProgressBar:(UIProgressView *)progressBar;

- (BOOL)addComment:(NSDictionary *)values;
- (BOOL)getComments:(NSMutableArray *)commentArray;

- (BOOL)addBrand:(NSDictionary *)values;
- (BOOL)getBrands:(NSMutableArray *)branderArray;

- (BOOL)getTopBrands:(NSMutableArray *)imageArray;

@end
