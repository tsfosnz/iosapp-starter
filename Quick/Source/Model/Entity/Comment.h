//
//  Comment.h
//  Gaje
//
//  Created by hello on 14-7-5.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Model.h"

@interface Comment : Model

@property (strong, nonatomic) NSString *commentUUID;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *create;
@property (strong, nonatomic) NSString *modified;

@property (strong, nonatomic) NSString *userUUID;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *usericon;

@property (strong, nonatomic) NSString *token;

@end
