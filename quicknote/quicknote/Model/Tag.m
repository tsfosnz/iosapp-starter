//
//  Tag.m
//  quicknote
//
//  Created by hello on 14-3-15.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "Tag.h"

@implementation Tag

- (id)init
{
    
    self = [super init];
    
    if (self) {
        self.table = @"tag";
        
        //self.fieldArray = [[NSMutableArray alloc] initWithArray:@[@"post_id", @"name", @"description"]];
        //self.fieldValueDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
    
}

- (BOOL)fetch:(NSMutableArray *)tagArray Filter:(NSString *)filter Order:(NSString *)order Page:(NSInteger)page PageSize:(NSInteger)pageSize
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"SELECT * FROM %@ WHERE %@ ORDER BY %@ LIMIT %d, %d";
    sql = [NSString stringWithFormat:sql, self.table, filter, order, page * pageSize, pageSize];
    
    FMResultSet *result = [self.db executeQuery:sql];
    
    while ([result next]) {
        
        Tag *tag = [[Tag alloc] init];
        
        tag.tagId = [result intForColumn:@"tag_id"];
        tag.name = [result stringForColumn:@"name"];
        [tagArray addObject:tag];
        
        tag = nil;
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
    
    NSString *sql = @"INSERT INTO %@ (name, name_index) VALUES (?, ?)";
    sql = [NSString stringWithFormat:sql, self.table];
    
    // can't replace table name with updateWithFormat
    
    [self.db executeUpdate:sql, self.name, self.nameIndex];
    
    self.tagId = (NSInteger)[self.db lastInsertRowId];
    
    return YES;
}

- (BOOL)update
{
    if (!self.db) {
        return NO;
    }
    
    self.nameIndex =[self escape:[[self.name substringToIndex:1] uppercaseString]];
    self.name = [self escape:self.name];
    
    NSString *sql = @"UPDATE %@ SET name=?, name_index=? WHERE tag_id=%d";
    sql = [NSString stringWithFormat:sql, self.table];
    
    [self.db executeUpdateWithFormat:sql, self.table, self.name, self.nameIndex, [NSNumber numberWithInteger:self.tagId]];
    
    return YES;
}

- (BOOL)remove
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM %@ WHERE tag_id=%d";
    
    [self.db executeUpdateWithFormat:sql, self.table, self.tagId];
    
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


@end
