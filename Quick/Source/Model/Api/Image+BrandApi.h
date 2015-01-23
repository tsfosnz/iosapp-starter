//
//  Image+BrandApi.h
//  Quick
//
//  Created by hello on 15-1-23.
//  Copyright (c) 2015年 hellomaya. All rights reserved.
//

#import "Image.h"

@interface Image (BrandApi)

- (BOOL)addBrand:(NSDictionary *)values
        Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)getBrands:(NSMutableArray *)branderArray
         Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)getTopBrands:(NSMutableArray *)imageArray
            Complete:(void (^)(NSInteger status, NSString *message))complete;

@end
