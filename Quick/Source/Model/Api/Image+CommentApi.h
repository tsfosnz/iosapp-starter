//
//  Image+CommentApi.h
//  Quick
//
//  Created by hello on 15-1-23.
//  Copyright (c) 2015年 hellomaya. All rights reserved.
//

#import "Image.h"

@interface Image (CommentApi)

- (BOOL)addComment:(NSDictionary *)values
          Complete:(void (^)(NSInteger status, NSString *message))complete;

- (BOOL)getComments:(NSMutableArray *)commentArray
           Complete:(void (^)(NSInteger status, NSString *message))complete;
@end
