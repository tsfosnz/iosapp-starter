//
//  Setting.m
//  Gaje
//
//  Created by hello on 14-12-31.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Setting.h"

@implementation Setting

+ (id)getInstance {
    static Setting *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

- (BOOL)addItem:(NSString *)key Value:(NSString *)value
{
    if (![self.db open]) {
        return NO;
    }
    
    self.name = [self escape:key];
    self.value = [self escape:value];
    
    if ([[self.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return NO;
    }
    
    if ([self getItem:self.name] != nil) {
        return NO;
    }
    
    [self.db executeUpdateWithFormat:@"INSERT INTO setting (name, value) VALUES (%@, %@);", self.name, self.value];
    
    
    return YES;
}

- (BOOL)updateItem:(NSString *)key Value:(NSString *)value
{
    if (![self.db open]) {
        return NO;
    }
    
    self.name = [self escape:key];
    self.value = [self escape:value];
    
    if ([[self.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return NO;
    }
    
    [self.db executeUpdateWithFormat:@"UPDATE setting SET name=%@, value=%@;", self.name, self.value];
    
    return YES;
}

- (BOOL)removeItem:(NSString *)key
{
    if (![self.db open]) {
        return NO;
    }
    
    self.name = [self escape:key];
    
    if ([[self.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return NO;
    }
    
    [self.db executeUpdateWithFormat:@"DELETE FROM setting WHERE name=%@;", self.name];
    
    return YES;
}

- (NSDictionary *)getItem:(NSString *)key
{
    if (![self.db open]) {
        return NO;
    }
    
    self.name = [self escape:key];
    
    FMResultSet *result;
    
    result = [self.db executeQueryWithFormat:@"SELECT * FROM setting WHERE name=%@", self.name];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    while ([result next]) {
    
        [data setObject:[result stringForColumn:@"value"] forKey:[result stringForColumn:@"name"]];
        return data;
    }
    
    return nil;
}

@end
