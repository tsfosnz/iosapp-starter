//
//  User.m
//  quicknote
//
//  Created by hello on 14-3-24.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "User.h"

@implementation User

+ (id)getInstance {
    static User *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

- (id)init
{
    
    self = [super init];
    
    if (self) {
        self.table = @"user";
        
    }
    
    return self;
    
}

- (BOOL)fetch:(NSMutableArray *)userArray Filter:(NSString *)filter Order:(NSString *)order Page:(NSInteger)page PageSize:(NSInteger)pageSize
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"SELECT * FROM %@ WHERE %@ ORDER BY %@ LIMIT %d, %d";
    
    sql = [NSString stringWithFormat:sql, self.table, filter, order, page * pageSize, pageSize];
    
    FMResultSet *result = [self.db executeQuery:sql];
    
    while ([result next]) {
        
        User *user = [[User alloc] init];
        
        user.userId = [result intForColumn:@"user_id"];
        user.name = [result stringForColumn:@"name"];
        
        [userArray addObject:user];
        
        user = nil;
        
    }
    
    return YES;
}


- (BOOL)add
{
    if (!self.db) {
        return NO;
    }
    
    self.name = [self escape:self.name];
    self.password = [self escape:self.password];
    
    NSString *sql = @"INSERT INTO %@ (name, password, status, active, last_login, last_logout) VALUES (?, ?, ?, ?, ?, ?)";
    
    sql = [NSString stringWithFormat:sql, self.table];
    
    [self.db executeUpdate:sql, self.name, self.password, [NSNumber numberWithInteger:self.status], [NSNumber numberWithInteger:self.active], [NSNumber numberWithInteger:self.lastLogin], [NSNumber numberWithInteger:self.lastLogout]];
    
    self.userId = (NSInteger)[self.db lastInsertRowId];
    
    return YES;
}

- (BOOL)update
{
    if (!self.db) {
        return NO;
    }
    
    self.name = [self escape:self.name];
    self.password = [self escape:self.password];
    
    NSString *sql = @"UPDATE %@ SET name=?, password=?, status=?, active=?, last_login=?, last_logout=? WHERE user_id=?";
    
    sql = [NSString stringWithFormat:sql, self.table];
    
    [self.db executeUpdate:sql, self.name, self.password, [NSNumber numberWithInteger:self.status], [NSNumber numberWithInteger:self.active], [NSNumber numberWithInteger:self.lastLogin], [NSNumber numberWithInteger:self.lastLogout], self.userId];
    
    return YES;
}


- (BOOL)remove
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM %@ WHERE user_id=%d";
    
    [self.db executeUpdateWithFormat:sql, self.table, self.userId];
    
    return YES;
}

- (BOOL)removeAll
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM %@";
    
    [self.db executeUpdate:[NSString stringWithFormat:sql, self.table]];
    
    return YES;
}

+ (NSString *)table
{
    return @"user";
}

@end
