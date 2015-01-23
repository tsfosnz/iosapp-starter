//
//  Brander.h
//  Gaje
//
//  Created by hello on 14-7-5.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Model.h"

@interface Brand : Model

@property (atomic, assign) NSInteger userId;
@property (atomic, retain) NSString *userUUID;
@property (atomic, retain) NSString *username;
@property (atomic, retain) NSString *desc;

@property (atomic, retain) NSString *firstname;
@property (atomic, retain) NSString *lastname;
@property (atomic, retain) NSString *fullname;
@property (atomic, retain) NSString *email;

@property (atomic, retain) NSString *icon;
@property (atomic, retain) NSString *iconurl;
@property (atomic, retain) UIImage *imageIcon;

@property (atomic, retain) NSString *city;
@property (atomic, retain) NSString *state;
@property (atomic, retain) NSString *country;
@property (atomic, retain) NSString *address;
@property (atomic, retain) NSString *postcode;
@property (atomic, retain) NSString *phone;

@property (atomic, retain) NSString *token;

@property (atomic, retain) NSString *errorMessage;

@end
