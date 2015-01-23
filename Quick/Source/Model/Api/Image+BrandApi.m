//
//  Image+BrandApi.m
//  Quick
//
//  Created by hello on 15-1-23.
//  Copyright (c) 2015年 hellomaya. All rights reserved.
//

#import "Image+BrandApi.h"

@implementation Image (BrandApi)



- (BOOL)addBrand:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    NSDictionary *parameters = values;
    
    NSString *api = [NSString stringWithFormat:API_IMAGE_BRANDER_ADD, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // NSLog(@"Success: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            //self.uploadedImageId = [responseObject objectForKey:@"id"];
            
        }
        
        [self changeUploadStatus:@"1"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //// NSLog(@"Error: %@", error);
        // NSLog(@"%@", [operation responseObject]);
        
        
        
    }];
    
    return YES;
    
}

- (BOOL)getBrands:(NSMutableArray *)branderArray Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    [branderArray removeAllObjects];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    
    NSDictionary *parameters = @{@"image_uuid":self.imageuuid};
    
    NSString *api = [NSString stringWithFormat:API_IMAGE_BRANDER_LIST, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            @try {
                
                NSArray *resultArray = [data objectForKey:@"branders"];
                
                if ([resultArray count] <= 0) {
                    
                } else {
                    
                    for (NSDictionary *item in resultArray) {
                        
                        Brand *brander = [[Brand alloc] init];
                        
                        brander.useruuid = [item objectForKey:@"user_uuid"];
                        brander.username = [item objectForKey:@"username"];
                        brander.fullname = [item objectForKey:@"fullname"];
                        brander.iconurl = [item objectForKey:@"facebook_icon"];
                        brander.token = [item objectForKey:@"facebook_token"];
                        
                        [branderArray addObject:brander];
                        
                    }
                    
                }
                
                
            }
            
            @catch (NSException *e) {
                
                
            }
            return;
            
        }
        
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
    return YES;
}


- (BOOL)getTopBrands:(NSMutableArray *)imageArray Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    
    NSMutableArray *tempImageArray = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [self getToken];
    User *user = [User getInstance];
    
    NSString *uuid = user.useruuid;
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    NSDictionary *parameters = @{@"user_uuid":@""};
    
    if (user.useruuid) {
        
        parameters = @{@"user_uuid":uuid};
    }
    
    NSString *api = [NSString stringWithFormat:API_IMAGE_BRANDER_TOP, API_BASE_URL, API_BASE_VERSION];
    
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
        
        // NSLog(@"%@", responseObject);
        
        if ([status isEqualToString:@"success"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            User *user = [User getInstance];
            
            @try {
                
                NSArray *$imageArray = [data objectForKey:@"images"];
                
                for (NSDictionary *item in $imageArray) {
                    
                    Image *image = [[Image alloc] init];
                    
                    image.imageuuid = [item objectForKey:@"image_uuid"];
                    image.name = [item objectForKey:@"name"];
                    image.desc = [item objectForKey:@"description"];
                    
                    image.width = [[item objectForKey:@"width"] integerValue];
                    image.height = [[item objectForKey:@"height"] integerValue];
                    
                    NSInteger timestamp = [[item objectForKey:@"create_date"] integerValue];
                    image.created = [self stringFromTimestamp:timestamp];
                    
                    timestamp = [[item objectForKey:@"modified_date"] integerValue];
                    image.modified = [self stringFromTimestamp:timestamp];
                    
                    image.fileName = [item objectForKey:@"file_name"];
                    image.url = [item objectForKey:@"url_file"];
                    
                    image.thumbnailName = [item objectForKey:@"thumbnail"];
                    image.thumbnail = [item objectForKey:@"url_thumbnail"];
                    
                    image.useruuid = [item objectForKey:@"user_uuid"];
                    image.username = [item objectForKey:@"username"];
                    image.usertoken = [item objectForKey:@"user_token"];
                    
                    image.usericon = [NSString stringWithFormat:FB_PROFILE_ICON, image.usertoken];
                    
                    image.branderCount = [[item objectForKey:@"brander_count"] integerValue];
                    image.enableBrandIt = [[item objectForKey:@"enable_brander"] integerValue];
                    
                    NSArray *resultArray = [item objectForKey:@"branders"];
                    
                    if ([resultArray count] <= 0) {
                        
                    } else {
                        
                        image.branderArray = [[NSMutableArray alloc] init];
                        
                        
                        for (NSDictionary *item2 in resultArray) {
                            
                            Brand *brander = [[Brand alloc] init];
                            
                            brander.useruuid = [item2 objectForKey:@"user_uuid"];
                            brander.username = [item2 objectForKey:@"username"];
                            brander.fullname = [item2 objectForKey:@"fullname"];
                            brander.iconurl = [item2 objectForKey:@"facebook_icon"];
                            brander.token = [item2 objectForKey:@"facebook_token"];
                            
                            if ([brander.useruuid isEqualToString:user.useruuid]) {
                                image.enableBrandIt = 0;
                            }
                            
                            [image.branderArray addObject:brander];
                            
                        }
                        
                    }
                    
                    //// NSLog(@"icon = %@", image.usericon);
                    [tempImageArray addObject:image];
                }
                
                [imageArray removeAllObjects];
                for (Image *image in tempImageArray) {
                    [imageArray addObject:image];
                }
                
            }
            
            @catch (NSException *e) {
                
                
            }
            
            return;
            
        }
        
        return;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // NSLog(@"%@", [operation responseObject]);
        // NSLog(@"%@", error);
        
        
    }];
    
    
    return YES;
}

@end
