//
//  Image+CommentApi.m
//  Quick
//
//  Created by hello on 15-1-23.
//  Copyright (c) 2015年 hellomaya. All rights reserved.
//

#import "Image+CommentApi.h"

@implementation Image (CommentApi)


- (BOOL)addComment:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    NSDictionary *parameters = values;
    
    NSString *api = [NSString stringWithFormat:API_IMAGE_COMMENT_ADD, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            //self.uploadedImageId = [responseObject objectForKey:@"id"];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
    return YES;
    
}

- (BOOL)getComments:(NSMutableArray *)commentArray Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    [commentArray removeAllObjects];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    NSDictionary *parameters = @{@"image_uuid":self.imageuuid};
    
    NSString *api = [NSString stringWithFormat:API_IMAGE_COMMENT_LIST, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        
        // NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            @try {
                
                NSArray *resultArray = [data objectForKey:@"comments"];
                
                if ([resultArray count] <= 0) {
                    
                } else {
                    
                    for (NSDictionary *item in resultArray) {
                        
                        
                        Comment *comment = [[Comment alloc] init];
                        
                        comment.content = [item objectForKey:@"content"];
                        comment.useruuid = [item objectForKey:@"user_uuid"];
                        comment.username = [item objectForKey:@"username"];
                        comment.usericon = [item objectForKey:@"usericon"];
                        
                        NSInteger timestamp = [[item objectForKey:@"create_date"] integerValue];
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                        
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        
                        formatter.timeZone = [NSTimeZone defaultTimeZone];
                        formatter.dateStyle = NSDateFormatterLongStyle;
                        
                        comment.create = [formatter stringFromDate:date];
                        
                        [commentArray addObject:comment];
                        
                    }
                    
                }
                
                
            }
            
            @catch (NSException *e) {
                
                
            }
            return;
            
        }
        
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        // NSLog(@"%@", error);
        
        
    }];
    
    
    return YES;
}

@end
