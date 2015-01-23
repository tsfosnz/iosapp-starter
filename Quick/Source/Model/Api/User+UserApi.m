//
//  User+UserApi.m
//  Gaje
//
//  Created by hello on 14-8-28.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "User+UserApi.h"
#import "Image.h"
#import "Brand.h"

@implementation User (UserApi)

// when we get FB id, we will login to server and create user for it
// then we will use this user uuid to upload image

- (BOOL)login:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    
    NSString *api = [NSString stringWithFormat:API_USER_LOGIN, API_BASE_URL, API_BASE_VERSION];
    NSDictionary *parameters = values;
    NSString* token = [self getToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSString *status = [responseObject objectForKey:@"status"];
              
              if ([status isEqualToString:@"success"]) {
                  
                  
                  NSDictionary *data = [responseObject objectForKey:@"data"];
                  
                  if ([data count] <= 0) {
                      return;
                  }
                  
                  NSString *uuid = [data objectForKey:@"user_uuid"];
                  
                  if ([uuid isEqual:[NSNull null]]) {
                      return;
                  }
                  
                  AppConfig *config = [AppConfig getInstance];
                  config.uuid = uuid;
                  
                  self.userUUID = uuid;
                  uuid = [data objectForKey:@"theme_uuid"];
                  
                  self.themeUUID = uuid;
                  [self updateUUID];
                  
                  complete(0, @"");
                  
                  return;
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              complete(1, @"");
          }];
    
    return NO;
}

- (BOOL)logout
{
    if (![self.db open]) {
        return NO;
    }
    
    [self remove];
    
    AppConfig *config = [AppConfig getInstance];
    config.userIsLogin = 0;
    config.token = @"";
    
    return YES;
}

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
                          
                          image.imageUUID = [item objectForKey:@"image_uuid"];
                          image.name = [item objectForKey:@"name"];
                          image.desc = [item objectForKey:@"description"];
                          
                          image.width = [[item objectForKey:@"width"] integerValue];
                          image.height = [[item objectForKey:@"height"] integerValue];
                          
                          image.fileName = [item objectForKey:@"file_name"];
                          image.url = [item objectForKey:@"url_file"];
                          
                          image.thumbnailName = [item objectForKey:@"thumbnail"];
                          image.thumbnail = [item objectForKey:@"url_thumbnail"];
                          
                          image.userUUID = [item objectForKey:@"user_uuid"];
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
                                  
                                  brander.userUUID = [item2 objectForKey:@"user_uuid"];
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
                          
                          follower.userUUID = [item objectForKey:@"user_uuid"];
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
                          
                          follower.userUUID = [item objectForKey:@"user_uuid"];
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

// block

- (BOOL)block:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    
    NSString *api = [NSString stringWithFormat:API_USER_BLOCK_ADD, API_BASE_URL, API_BASE_VERSION];
    
    NSString *token = [self getToken];
    NSDictionary *parameters = values;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"success"]) {
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    return YES;
    
}

- (BOOL)search:(NSDictionary *)values ResultArray:(NSMutableArray *)userArray Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    
    NSString *api = [NSString stringWithFormat:API_USER_SEARCH, API_BASE_URL, API_BASE_VERSION];
    
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
                      
                      NSArray *resultArray = [data objectForKey:@"users"];
                      
                      //if ([resultArray count] > 0) {
                      [userArray removeAllObjects];
                      //}
                      
                      for (NSDictionary *item in resultArray) {
                          
                          User *user = [[User alloc] init];
                          
                          user.userUUID = [item objectForKey:@"user_uuid"];
                          user.username = [item objectForKey:@"username"];
                          user.fullname = [item objectForKey:@"fullname"];
                          
                          user.token = [item objectForKey:@"facebook_token"];
                          user.icon = user.token;
                          user.iconurl = [item objectForKey:@"facebook_icon"];
                          user.isMutual = [[item objectForKey:@"is_mutual"] integerValue];
                          
                          [userArray addObject:user];
                      }
                      
                      
                  }
                  
                  @catch (NSException *e) {
                      
                      
                      
                  }
                  
                  
              }
              
              
              return;
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];
    
    
    return YES;
}





- (BOOL)getLatestUpdate:(NSDictionary *)updateDictionary Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    if (!self.userUUID) {
        return NO;
    }
    
    NSString *api = [NSString stringWithFormat:API_USER_GET_NOTIFY, API_BASE_URL, API_BASE_VERSION];
    
    NSDictionary *data = @{@"user_uuid":self.userUUID};
    NSDictionary *parameters = data;
    NSString* token = [self getToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
              NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
              
              if ([status isEqualToString:@"success"]) {
                  
                  NSDictionary *data = [responseObject objectForKey:@"data"];
                  
                  @try {
                      
                      
                      NSMutableArray *commentsArray = [[NSMutableArray alloc] init];
                      NSMutableArray *branderArray = [[NSMutableArray alloc] init];
                      
                      NSArray *$imageArray = [data objectForKey:@"comments"];
                      
                      for (NSDictionary *item in $imageArray) {
                          
                          Image *image = [[Image alloc] init];
                          
                          image.imageUUID = [item objectForKey:@"image_uuid"];
                          image.name = [item objectForKey:@"name"];
                          image.desc = [item objectForKey:@"description"];
                          
                          image.width = [[item objectForKey:@"width"] integerValue];
                          image.height = [[item objectForKey:@"height"] integerValue];
                          
                          NSInteger timestamp = [[item objectForKey:@"create_date"] integerValue];
                          NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                          
                          NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                          
                          formatter.timeZone = [NSTimeZone defaultTimeZone];
                          formatter.dateStyle = NSDateFormatterLongStyle;
                          
                          image.created = [formatter stringFromDate:date];
                          
                          timestamp = [[item objectForKey:@"modified_date"] integerValue];
                          date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                          
                          image.modified = [formatter stringFromDate:date];
                          image.fileName = [item objectForKey:@"file_name"];
                          image.url = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, image.fileName];
                          
                          
                          image.thumbnailName = [item objectForKey:@"thumbnail"];
                          image.thumbnail = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, image.thumbnailName];
                          
                          image.userUUID = [item objectForKey:@"user_uuid"];
                          image.username = [item objectForKey:@"username"];
                          image.usertoken = [item objectForKey:@"user_token"];
                          
                          image.commentUUID = [item objectForKey:@"comment_uuid"];
                          image.status = [[item objectForKey:@"is_read"] integerValue];
                          
                          image.usericon = [NSString stringWithFormat:FB_PROFILE_ICON, image.usertoken];
                          
                          image.branderCount = [[item objectForKey:@"brander_count"] integerValue];
                          image.enableBrandIt = [[item objectForKey:@"enable_brander"] integerValue];
                          
                          NSArray *resultArray = [item objectForKey:@"branders"];
                          
                          if ([resultArray count] <= 0) {
                              
                          } else {
                              
                              image.branderArray = [[NSMutableArray alloc] init];
                              
                              
                              for (NSDictionary *item2 in resultArray) {
                                  
                                  Brand *brander = [[Brand alloc] init];
                                  
                                  brander.userUUID = [item2 objectForKey:@"user_uuid"];
                                  brander.username = [item2 objectForKey:@"username"];
                                  brander.fullname = [item2 objectForKey:@"fullname"];
                                  brander.iconurl = [item2 objectForKey:@"facebook_icon"];
                                  brander.token = [item2 objectForKey:@"facebook_token"];
                                  
                                  
                                  [image.branderArray addObject:brander];
                                  
                              }
                              
                          }
                          
                          [commentsArray addObject:image];
                          
                      }
                      
                      
                      $imageArray = [data objectForKey:@"branders"];
                      
                      for (NSDictionary *item in $imageArray) {
                          
                          Image *image = [[Image alloc] init];
                          
                          image.imageUUID = [item objectForKey:@"image_uuid"];
                          image.name = [item objectForKey:@"name"];
                          image.desc = [item objectForKey:@"description"];
                          
                          image.width = [[item objectForKey:@"width"] integerValue];
                          image.height = [[item objectForKey:@"height"] integerValue];
                          
                          NSInteger timestamp = [[item objectForKey:@"create_date"] integerValue];
                          NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                          
                          NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                          
                          formatter.timeZone = [NSTimeZone defaultTimeZone];
                          formatter.dateStyle = NSDateFormatterLongStyle;
                          
                          image.created = [formatter stringFromDate:date];
                          
                          timestamp = [[item objectForKey:@"modified_date"] integerValue];
                          date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                          
                          image.modified = [formatter stringFromDate:date];
                          image.fileName = [item objectForKey:@"file_name"];
                          image.url = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, image.fileName];
                          
                          
                          image.thumbnailName = [item objectForKey:@"thumbnail"];
                          image.thumbnail = [NSString stringWithFormat:@"%@%@", URL_BASE_IMAGE, image.thumbnailName];
                          
                          image.userUUID = [item objectForKey:@"user_uuid"];
                          image.username = [item objectForKey:@"username"];
                          image.usertoken = [item objectForKey:@"user_token"];
                          
                          image.branderUUID = [item objectForKey:@"brander_user_uuid"];
                          image.status = [[item objectForKey:@"is_read"] integerValue];
                          
                          image.usericon = [NSString stringWithFormat:FB_PROFILE_ICON, image.usertoken];
                          
                          image.branderCount = [[item objectForKey:@"brander_count"] integerValue];
                          image.enableBrandIt = [[item objectForKey:@"enable_brander"] integerValue];
                          
                          NSArray *resultArray = [item objectForKey:@"branders"];
                          
                          if ([resultArray count] <= 0) {
                              
                          } else {
                              
                              image.branderArray = [[NSMutableArray alloc] init];
                              
                              
                              for (NSDictionary *item2 in resultArray) {
                                  
                                  Brand *brander = [[Brand alloc] init];
                                  
                                  brander.userUUID = [item2 objectForKey:@"user_uuid"];
                                  brander.username = [item2 objectForKey:@"username"];
                                  brander.fullname = [item2 objectForKey:@"fullname"];
                                  brander.iconurl = [item2 objectForKey:@"facebook_icon"];
                                  brander.token = [item2 objectForKey:@"facebook_token"];
                                  
                                  
                                  [image.branderArray addObject:brander];
                                  
                              }
                              
                          }
                          
                          [branderArray addObject:image];
                          
                      }
                      
                      NSArray *resultArray = [data objectForKey:@"followers"];
                      NSMutableArray *followerArray = [[NSMutableArray alloc] init];
                      
                      for (NSDictionary *item in resultArray) {
                          
                          User *follower = [[User alloc] init];
                          
                          follower.userUUID = [item objectForKey:@"user_uuid"];
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
                      
                      [updateDictionary setValue:commentsArray forKey:@"comments"];
                      [updateDictionary setValue:branderArray forKey:@"branders"];
                      [updateDictionary setValue:followerArray forKey:@"followers"];
                      
                      //// NSLog(@"update = %d", [commentsArray count]);
                      
                      
                      
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

- (BOOL)registerDevToken:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    
    if (!self.userUUID) {
        return NO;
    }
    
    
    NSString *api = [NSString stringWithFormat:API_APN_REGISTER, API_BASE_URL, API_BASE_VERSION];
    
    NSDictionary *parameters = values;
    NSString* token = [self getToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
              
              if ([status isEqualToString:@"success"]) {
                  
                  
              }
              
              return;
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];
    
    return YES;
}

- (BOOL)enableAPN:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    if (!self.userUUID) {
        return NO;
    }
    
    NSString *api = [NSString stringWithFormat:API_APN_ENABLE, API_BASE_URL, API_BASE_VERSION];
    
    NSDictionary *parameters = values;
    NSString* token = [self getToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              
              NSString *status = [(NSDictionary *)responseObject objectForKey:@"status"];
              
              if ([status isEqualToString:@"success"]) {
                  
                  
              }
              
              return;
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              
              NSLog(@"Error: %@", operation.response);
              NSLog(@"Error: %@", operation.responseObject);
          }];
    
    return YES;
}

- (BOOL)markItRead:(NSDictionary *)values Complete:(void (^)(NSInteger status, NSString *message))complete;
{
    if (!self.userUUID) {
        
        return NO;
    }
    
    NSString *api = [NSString stringWithFormat:API_USER_UPDATE_NOTIFY, API_BASE_URL, API_BASE_VERSION];
    
    NSDictionary *parameters = values;
    NSString* token = [self getToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-KEY"];
    
    [manager POST:api parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              // NSLog(@"JSON: %@", responseObject);
              
              return;
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];
    
    return YES;
}

@end
