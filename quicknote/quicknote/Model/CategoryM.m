//
//  CategoryModel.m
//  quicknote
//
//  Created by hello on 14-3-21.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "CategoryM.h"

@implementation CategoryM
- (id)init
{
    
    self = [super init];
    
    if (self) {
        self.table = @"category";
        
    }
    
    return self;
    
}

- (BOOL)fetch:(NSMutableArray *)categoryArray Filter:(NSString *)filter Order:(NSString *)order Page:(NSInteger)page PageSize:(NSInteger)pageSize
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"SELECT * FROM %@ WHERE %@ ORDER BY %@ LIMIT %d, %d";
    
    sql = [NSString stringWithFormat:sql, self.table, filter, order, page * pageSize, pageSize];
    
    FMResultSet *result = [self.db executeQuery:sql];
    
    while ([result next]) {
        
        CategoryM *category = [[CategoryM alloc] init];
        
        category.categoryId = [result intForColumn:@"category_id"];
        category.name = [result stringForColumn:@"name"];
        
        [categoryArray addObject:category];
        
        category = nil;
        
    }
    
    
    return YES;
}

- (BOOL)add
{
    if (!self.db) {
        return NO;
    }

    
    self.nameIndex =[self escape:[[self.name substringToIndex:1] uppercaseString]];
    self.name = [self escape:self.name];
    self.family = [self escape:self.family];
    
    NSString *sql = @"INSERT INTO %@ (name, name_index, level, sort, family) VALUES (?, ?, ?, ?, ?)";
    
    sql = [NSString stringWithFormat:sql, self.table];
    
    [self.db executeUpdate:sql, self.name, self.nameIndex, [NSNumber numberWithInteger:self.level], [NSNumber numberWithInteger:self.sort], self.family];
    
    self.categoryId = (NSInteger)[self.db lastInsertRowId];
    self.family = [NSString stringWithFormat:@"%d", self.categoryId];
    
    NSLog(@"family = %@", self.family);
    
    sql = @"UPDATE %@ SET family=? WHERE category_id=%d";
    sql = [NSString stringWithFormat:sql, self.table, self.categoryId];
    [self.db executeUpdate:sql, self.family];
    
    return YES;
}

- (BOOL)update
{
    if (!self.db) {
        return NO;
    }
    
    self.nameIndex =[self escape:[[self.name substringToIndex:1] uppercaseString]];
    self.name = [self escape:self.name];
    self.family = [self escape:self.family];
    
    NSString *sql = @"UPDATE %@ SET name=?, name_index=?, level=?, sort=?, family=%@ WHERE category_id=?";
    
    sql = [NSString stringWithFormat:sql, self.table];
    
    [self.db executeUpdate:sql, self.name, self.nameIndex, [NSNumber numberWithInteger:self.level], [NSNumber numberWithInteger:self.sort], self.family, [NSNumber numberWithInteger:self.categoryId]];
    
    return YES;
}


- (BOOL)remove
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM %@ WHERE category_id=?";
    
    sql = [NSString stringWithFormat:sql, self.table];
    
    [self.db executeUpdate:sql, self.categoryId];
    
    return YES;
}

- (BOOL)removeAll
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM %@";
    
    
    return YES;
}

+ (NSString *)table
{
    return @"category";
}

@end
