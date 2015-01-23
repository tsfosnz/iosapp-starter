//
//  Theme.m
//  Gaje
//
//  Created by hello on 14-7-2.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Theme.h"

@implementation Theme

+ (id)getInstance {
    static Theme *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

//=======================
//
//=======================

- (BOOL)fetchList:(NSMutableArray *)themeArray
{
    
       
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
  NSString *token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *parameters = @{};
    
    
    [manager POST:[NSString stringWithFormat:API_THEME_LIST, API_BASE_URL, API_BASE_VERSION] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            @try {
                
                NSArray *resultArray = [data objectForKey:@"themes"];
                NSInteger i = 0;
                
                if ([resultArray count] > 0) {
                    
                    [themeArray removeAllObjects];
                }
                
                for (NSDictionary *item in resultArray) {
                    
                    Theme *theme = [[Theme alloc] init];
                    
                    theme.themeuuid = [item objectForKey:@"theme_uuid"];
                    theme.name = [item objectForKey:@"name"];
                    theme.desc = [item objectForKey:@"description"];
                    
                    if (i == 0) {
                        
                        theme.selected = YES;
                        i++;
                    } else {
                    
                        theme.selected = NO;
                    }
                    
                    [themeArray addObject:theme];
                    theme = nil;
                }
                
            }
            
            @catch (NSException *e) {
                
                
            }
            return;
            
        }
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
           
        
        // NSLog(@"%@", error);
        // NSLog(@"%@", [operation responseObject]);
    }];
    
    
    return YES;
}

@end
