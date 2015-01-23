//
//  User+FollowApi.m
//  Quick
//
//  Created by hello on 15-1-23.
//  Copyright (c) 2015年 hellomaya. All rights reserved.
//

#import "User+FollowApi.h"
#import "Image.h"

@implementation User (FollowApi)


- (BOOL)follow:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    
    NSString *api = [NSString stringWithFormat:API_USER_FOLLOW, API_BASE_URL, API_BASE_VERSION];
    
    NSDictionary *parameters = values;
    NSString *token = [self getToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              //NSLog(@"Success: %@", responseObject);
              
              NSString *status = [responseObject objectForKey:@"status"];
              
              if ([status isEqualToString:@"success"]) {
                  
                  //self.uploadedImageId = [responseObject objectForKey:@"id"];
                  
              }
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              //NSLog(@"Error: %@", error);
              
          }];
    
    return YES;
    
}

- (BOOL)unfollow:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    
    NSString *api = [NSString stringWithFormat:API_USER_UNFOLLOW, API_BASE_URL, API_BASE_VERSION];
    
    NSDictionary *parameters = values;
    NSString *token = [self getToken];
    
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
              
              // NSLog(@"Error: %@", error);
              
          }];
    
    return YES;
    
}

- (BOOL)getFollowers:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    NSString *api = [NSString stringWithFormat:API_USER_FOLLOWER_LIST, API_BASE_URL, API_BASE_VERSION];
    
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
                  
                  @try {
                      
                      NSArray *resultArray = [data objectForKey:@"followers"];
                      
                      //if ([resultArray count] > 0) {
                      [followerArray removeAllObjects];
                      //}
                      
                      for (NSDictionary *item in resultArray) {
                          
                          User *follower = [[User alloc] init];
                          
                          follower.useruuid = [item objectForKey:@"user_uuid"];
                          follower.username = [item objectForKey:@"username"];
                          follower.fullname = [item objectForKey:@"fullname"];
                          
                          follower.token = [item objectForKey:@"facebook_token"];
                          follower.icon = follower.token;
                          follower.iconurl = [item objectForKey:@"facebook_icon"];
                          follower.isMutual = [[item objectForKey:@"is_mutual"] integerValue];
                          
                          NSDictionary *image = [item objectForKey:@"image"];
                          
                          if ([image count] > 0) {
                              
                              if (!follower.imageArray) {
                                  
                                  follower.imageArray = [[NSMutableArray alloc] init];
                                  
                              }
                              
                              Image *_image = [[Image alloc] init];
                              
                              _image.name = [image objectForKey:@"name"];
                              _image.desc = [image objectForKey:@"description"];
                              _image.fileName = [image objectForKey:@"file_name"];
                              _image.thumbnailName = [image objectForKey:@"thumbnail"];
                              _image.thumbnail = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, _image.thumbnailName];
                              
                              _image.width = [[image objectForKey:@"width"] integerValue];
                              _image.height = [[image objectForKey:@"height"] integerValue];
                              
                              [follower.imageArray addObject:_image];
                              
                          }
                          
                          [followerArray addObject:follower];
                      }
                      
                  }
                  
                  @catch (NSException *e) {
                      
                      
                      
                  }
                  return;
                  
              }
              
              return;
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              //NSLog(@"%@", [operation responseObject]);
              //NSLog(@"%@", error);
              
          }];
    
    
    return YES;
}

- (BOOL)getFollowings:(NSDictionary *)values ResultArray:(NSMutableArray *)followerArray Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    
    NSString *api = [NSString stringWithFormat:API_USER_FOLLOWIN_LIST, API_BASE_URL, API_BASE_VERSION];
    NSString *token = [self getToken];
    NSDictionary *parameters = values;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
              
              if ([status isEqualToString:@"success"]) {
                  
                  NSDictionary *data = [responseObject objectForKey:@"data"];
                  
                  @try {
                      
                      NSArray *resultArray = [data objectForKey:@"followings"];
                      
                      //if ([resultArray count] > 0) {
                      [followerArray removeAllObjects];
                      //}
                      
                      for (NSDictionary *item in resultArray) {
                          
                          User *follower = [[User alloc] init];
                          
                          follower.useruuid = [item objectForKey:@"user_uuid"];
                          follower.username = [item objectForKey:@"username"];
                          follower.fullname = [item objectForKey:@"fullname"];
                          
                          follower.token = [item objectForKey:@"facebook_token"];
                          follower.icon = follower.token;
                          follower.iconurl = [item objectForKey:@"facebook_icon"];
                          follower.isMutual = [[item objectForKey:@"is_mutual"] integerValue];
                          
                          NSDictionary *image = [item objectForKey:@"image"];
                          
                          if ([image count] > 0) {
                              
                              if (!follower.imageArray) {
                                  
                                  follower.imageArray = [[NSMutableArray alloc] init];
                                  
                              }
                              
                              Image *_image = [[Image alloc] init];
                              
                              _image.name = [image objectForKey:@"name"];
                              _image.desc = [image objectForKey:@"description"];
                              _image.fileName = [image objectForKey:@"file_name"];
                              _image.thumbnailName = [image objectForKey:@"thumbnail"];
                              _image.thumbnail = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, _image.thumbnailName];
                              
                              _image.width = [[image objectForKey:@"width"] integerValue];
                              _image.height = [[image objectForKey:@"height"] integerValue];
                              
                              [follower.imageArray addObject:_image];
                              
                          }
                          
                          [followerArray addObject:follower];
                      }
                      
                      
                      
                  }
                  
                  @catch (NSException *e) {
                      
                      
                  }
                  
                  return;
                  
              }
              
              
              
              return;
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              //NSLog(@"%@", [operation responseObject]);
              //NSLog(@"%@", error);
          }];
    
    
    return YES;
}

@end
