//
//  Auth.m
//  Pixcell8
//
//  Created by  ()
//  Copyright (c) 2013-2014 
//

#import "User.h"
#import "Image.h"
#import "Brand.h"

@implementation User


+ (id)getInstance {
    static User *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}


- (BOOL)add
{
    if (![self.db open]) {
        return NO;
    }
    
    self.username = [self escape:self.username];
    self.desc = [self escape:self.desc];
    self.fullname = [self escape:self.fullname];
    self.email = [self escape:self.email];
    self.city = [self escape:self.city];
    self.state = [self escape:self.state];
    self.country = [self escape:self.country];
    self.address = [self escape:self.address];
    self.postcode = [self escape:self.postcode];
    self.postcode = [self escape:self.phone];
    self.icon = [self escape:self.icon];
    self.token = [self escape:self.token];
    self.phone = [self escape:self.phone];
    self.location = [self escape:self.location];
    
    self.useruuid = [self escape:self.useruuid];
    
    self.themeuuid = [self escape:self.themeuuid];
    
    
    [self.db executeUpdateWithFormat:@"DELETE FROM user WHERE token=%@", self.token];
    
    [self.db executeUpdateWithFormat:@"INSERT INTO user (user_uuid, username, description, fullname, email, token, location, theme_uuid) VALUES (%@, %@, %@, %@, %@, %@, %@, %@);", self.useruuid, self.username, self.desc, self.fullname, self.email, self.token, self.location, self.themeuuid];
    
    
    return YES;
}

- (BOOL)update
{
    if (![self.db open]) {
        return NO;
    }
    
    self.username = [self escape:self.username];
    self.desc = [self escape:self.desc];
    self.fullname = [self escape:self.fullname];
    self.email = [self escape:self.email];
    self.city = [self escape:self.city];
    self.state = [self escape:self.state];
    self.country = [self escape:self.country];
    self.address = [self escape:self.address];
    self.postcode = [self escape:self.postcode];
    self.postcode = [self escape:self.phone];
    self.icon = [self escape:self.icon];
    self.token = [self escape:self.token];
    self.phone = [self escape:self.phone];
    
    [self.db executeUpdateWithFormat:@"UPDATE user SET username=%@, description=%@, fullname=%@, email=%@, city=%@, state=%@, country=%@, address=%@, zipcode＝%@, phone=%@, picture=%@, token=%@ WHERE user_id=%ld", self.username, self.desc, self.fullname, self.email, self.city, self.state, self.country, self.address, self.postcode, self.phone, self.icon, self.token, (long)(self.userId)];
    
    return YES;
}

- (BOOL)updateuuid
{
    if (![self.db open]) {
        return NO;
    }
    
    self.useruuid = [self escape:self.useruuid];
    self.themeuuid = [self escape:self.themeuuid];
    
    [self.db executeUpdateWithFormat:@"UPDATE user SET user_uuid=%@, theme_uuid=%@ WHERE token=%@", self.useruuid, self.themeuuid, self.token];
    
    return YES;
}

- (BOOL)remove
{
    if (![self.db open]) {
        return NO;
    }
    
    self.token = [self escape:self.token];
    [self.db executeUpdateWithFormat:@"DELETE FROM user WHERE token=%@", self.token];
    
    return YES;
}

- (BOOL)exits
{
    if (![self.db open]) {
        return NO;
    }
    
    FMResultSet *result;
    
    result = [self.db executeQueryWithFormat:@"SELECT * FROM user WHERE token=%@", self.token];
    
    self.userId = 0;
    
    while ([result next]) {
        
        return YES;
    }
    
    return NO;
}

- (BOOL)auth
{
    if (![self.db open]) {
        return NO;
    }
    
    FMResultSet *result;
    result = [self.db executeQueryWithFormat:@"SELECT * FROM user"];
    
    while ([result next]) {
        
        self.userId = [result intForColumn:@"user_id"];
        self.username = [result stringForColumn:@"username"];
        self.desc = [result stringForColumn:@"description"];
        
        self.email = [result stringForColumn:@"email"];
        
        self.fullname = [result stringForColumn:@"fullname"];
        self.city = [result stringForColumn:@"city"];
        self.state = [result stringForColumn:@"state"];
        self.country = [result stringForColumn:@"country"];
        self.address = [result stringForColumn:@"address"];
        self.postcode = [result stringForColumn:@"zipcode"];
        self.phone = [result stringForColumn:@"phone"];
        
        self.token = [result stringForColumn:@"token"];
        self.useruuid = [result stringForColumn:@"user_uuid"];
        self.location = [result stringForColumn:@"location"];
        
        self.themeuuid = [result stringForColumn:@"theme_uuid"];
        
        self.icon = self.token;
        self.iconurl = [NSString stringWithFormat:FB_PROFILE_ICON, self.token];
        
        AppConfig *config = [AppConfig getInstance];
        config.userIsLogin = 1;
        config.uuid = self.useruuid;
        config.token = self.token;        
    }
    
    return YES;
}

- (BOOL)fetchByToken:(NSString *)token
{
    if (![self.db open]) {
        return NO;
    }
    
    FMResultSet *result;
    
    token = [self escape:token];
    
    result = [self.db executeQueryWithFormat:@"SELECT * FROM user WHERE token=%@", token];
    
    self.userId = 0;
    
    while ([result next]) {
        
        self.userId = [result intForColumn:@"user_id"];
        self.username = [result stringForColumn:@"username"];
        self.desc = [result stringForColumn:@"description"];
        
        self.email = [result stringForColumn:@"email"];
        
        self.fullname = [result stringForColumn:@"fullname"];
        self.city = [result stringForColumn:@"city"];
        self.state = [result stringForColumn:@"state"];
        self.country = [result stringForColumn:@"country"];
        self.address = [result stringForColumn:@"address"];
        self.postcode = [result stringForColumn:@"zipcode"];
        self.phone = [result stringForColumn:@"phone"];
        
        self.token = [result stringForColumn:@"token"];
    }
    
    return YES;
}

@end
