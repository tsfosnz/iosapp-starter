//
//  User.h
//  quicknote
//
//  Created by hello on 14-3-24.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "Model.h"

@interface User : Model

@property (atomic, assign) NSInteger userId;
@property (atomic, retain) NSString *name;
@property (atomic, retain) NSString *password;
@property (atomic, retain) NSString *email;
@property (atomic, assign) NSInteger status;
@property (atomic, assign) NSInteger active;
@property (atomic, assign) NSInteger lastLogin;
@property (atomic, assign) NSInteger lastLogout;

+ (id)getInstance;

@end
