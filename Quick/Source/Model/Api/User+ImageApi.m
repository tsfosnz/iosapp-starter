//
//  User+ImageApi.m
//  Quick
//
//  Created by hello on 15-1-23.
//  Copyright (c) 2015年 hellomaya. All rights reserved.
//

#import "User+ImageApi.h"
#import "Image.h"

@implementation User (ImageApi)


- (BOOL)getImages:(NSMutableArray *)imageArray Parameters:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    
    NSString *api = [NSString stringWithFormat:API_USER_IMAGE_LIST, API_BASE_URL, API_BASE_VERSION];
    
    NSDictionary *parameters = values;
    NSString *token = [self getToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
              
              if ([status isEqualToString:@"success"]) {
                  
                  NSDictionary *data = [responseObject objectForKey:@"data"];
                  NSMutableArray *_result = [[NSMutableArray alloc] init];
                  
                  @try {
                      
                      NSArray *$imageArray = [data objectForKey:@"images"];
                      
                      for (NSDictionary *item in $imageArray) {
                          
                          Image *image = [[Image alloc] init];
                          
                          image.imageuuid = [item objectForKey:@"image_uuid"];
                          image.name = [item objectForKey:@"name"];
                          image.desc = [item objectForKey:@"description"];
                          
                          image.width = [[item objectForKey:@"width"] integerValue];
                          image.height = [[item objectForKey:@"height"] integerValue];
                          
                          image.fileName = [item objectForKey:@"file_name"];
                          image.url = [item objectForKey:@"url_file"];
                          
                          image.thumbnailName = [item objectForKey:@"thumbnail"];
                          image.thumbnail = [item objectForKey:@"url_thumbnail"];
                          
                          image.useruuid = [item objectForKey:@"user_uuid"];
                          image.username = [item objectForKey:@"username"];
                          image.usertoken = [item objectForKey:@"user_token"];
                          image.usericon = [NSString stringWithFormat:FB_PROFILE_ICON, image.usertoken];
                          image.branderCount = [[item objectForKey:@"brander_count"] integerValue];
                          
                          // time & date
                          
                          NSInteger timestamp = [[item objectForKey:@"create_date"] integerValue];
                          image.created = [self stringFromTimestamp:timestamp];
                          
                          timestamp = [[item objectForKey:@"modified_date"] integerValue];
                          image.modified = [self stringFromTimestamp:timestamp];
                          
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
                                  
                                  
                                  [image.branderArray addObject:brander];
                                  
                              }
                              
                          }
                          
                          //// NSLog(@"icon = %@", image.usericon);
                          [_result addObject:image];
                      }
                      
                      [imageArray removeAllObjects];
                      
                      for (Image *image in _result) {
                          [imageArray addObject:image];
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

- (BOOL)removeImage:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *token = [self getToken];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    NSDictionary *parameters = values;
    
    
    NSString *api = [NSString stringWithFormat:API_USER_REMOVE_IMAGE, API_BASE_URL, API_BASE_VERSION];
    [manager POST:api parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSString *status = [responseObject objectForKey:@"status"];
              
              if ([status isEqualToString:@"success"]) {
                  
                  //self.uploadedImageId = [responseObject objectForKey:@"id"];
                  
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              
              
          }];
    
    return YES;
    
}

// exclude image

- (BOOL)excludeImage:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    
    NSString *api = [NSString stringWithFormat:API_USER_EXCLUDE_IMAGE, API_BASE_URL, API_BASE_VERSION];
    
    NSString *token = [self getToken];
    NSDictionary *parameters = values;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              // NSLog(@"Success: %@", responseObject);
              
              NSString *status = [responseObject objectForKey:@"status"];
              
              if ([status isEqualToString:@"success"]) {
                  
                  //self.uploadedImageId = [responseObject objectForKey:@"id"];
                  
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              
          }];
    
    return YES;
    
}

@end
