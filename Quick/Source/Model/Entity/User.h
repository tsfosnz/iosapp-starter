//
//  Auth.h
//  Pixcell8
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//

//  DB tables - users - id, useranme, password, token, status, login date, logout date, counts

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Model.h"
#import "Global.h"

@interface User : Model

@property (atomic, assign) NSInteger userId;
@property (atomic, retain) NSString *useruuid;
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
@property (atomic, strong) NSString *location;


// update

@property (assign) NSInteger status;

@property (strong) NSString *themeuuid;

@property (atomic, retain) NSString *token;
@property (nonatomic, assign) NSInteger isMutual;

@property (atomic, strong) NSMutableArray *imageArray;



+ (id)getInstance;

- (BOOL)auth;
- (BOOL)fetchByToken:(NSString *)token;
- (BOOL)add;
- (BOOL)updateuuid;
- (BOOL)remove;
- (BOOL)exits;

@end
