//
//  Post.m
//  quicknote
//
//  Created by hello on 14-3-11.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "Post.h"

@implementation Post

- (id)init
{
    
    self = [super init];
    
    if (self) {
        self.table = @"post";
        self.tablePostToTag = @"post_to_tag";
        self.tablePostToMark = @"post_to_mark";
        self.tableTag = @"tag";
        self.tableMark = @"mark";
        
        //self.fieldArray = [[NSMutableArray alloc] initWithArray:@[@"post_id", @"name", @"description"]];
        //self.fieldValueDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
    
}

- (BOOL)fetch:(NSMutableArray *)postArray Filter:(NSString *)filter Order:(NSString *)order Page:(NSInteger)page PageSize:(NSInteger)pageSize
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"SELECT * FROM %@ AS p INNER JOIN %@ AS pt ON p.post_id=pt.post_id INNER JOIN %@ AS t ON pt.tag_id=t.tag_id WHERE %@ ORDER BY %@ LIMIT %d, %d";
    
    FMResultSet *result = [self.db executeQueryWithFormat:sql, self.table, self.tablePostToTag, self.tableTag, filter, order, page * pageSize, pageSize];
    
    while ([result next]) {
        
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
    self.description = [self escape:self.description];
    self.location = [self escape:self.location];
    self.address = [self escape:self.address];
    self.longitude = [self escape:self.longitude];
    self.latitude = [self escape:self.latitude];
    self.watermark = [self escape:self.watermark];
    
    NSString *sql = @"INSERT INTO %@ (name, name_index, description, location, address, longitude, latitude, watermark, created, updated) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    //sql = @"INSERT INTO %@ (name, name_index) VALUES (?, ?)";
    sql = [NSString stringWithFormat:sql, self.table];
    
    [self.db executeUpdate:sql, self.name, self.nameIndex, self.description, self.location, self.address, self.longitude, self.latitude, self.watermark, [NSNumber numberWithInteger:self.created], [NSNumber numberWithInteger:self.updated]];
    
    self.postId = (NSInteger)[self.db lastInsertRowId];
    
    return YES;
}

- (BOOL)update
{
    if (!self.db) {
        return NO;
    }
    
    self.nameIndex =[self escape:[[self.name substringToIndex:1] uppercaseString]];
    self.name = [self escape:self.name];
    self.description = [self escape:self.description];
    self.location = [self escape:self.location];
    self.address = [self escape:self.address];
    self.longitude = [self escape:self.longitude];
    self.latitude = [self escape:self.latitude];
    self.watermark = [self escape:self.watermark];
    
    NSString *sql = @"UPDATE %@ SET name=?, name_index=?, description=?, location=?, address=?, longitude=?, latitude=?, watermark=?, created=?, updated=? WHERE post_id=?";
    
    sql = [NSString stringWithFormat:sql, self.table];
    
    [self.db executeUpdate:sql, self.name, self.nameIndex, self.description, self.location, self.address, self.longitude, self.latitude, self.watermark, [NSNumber numberWithInteger:self.created], [NSNumber numberWithInteger:self.updated], [NSNumber numberWithInteger:self.postId]];
    
    return YES;
}

- (BOOL)updateTag:(NSArray *)tagArray
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql;
    
    sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE post_id=%d", self.tablePostToTag, self.postId];
    [self.db executeUpdate:sql];
    
    sql = @"INSERT INTO %@ (post_id, tag_id) VALUES (?, ?)";
    sql = [NSString stringWithFormat:sql, self.tablePostToTag];
    
    for (Tag *tag in tagArray) {
        [self.db executeUpdate:sql, [NSNumber numberWithInteger:self.postId], [NSNumber numberWithInteger:tag.tagId]];
    }
    
    return YES;
}

- (BOOL)updateMark
{
    if (!self.db) {
        return NO;
    }
    
    //NSString *sql = @"UPDATE %@ SET post_id=%ld, mark_id=%ld WHERE post_id=%ld";
    
    //[self.db executeUpdateWithFormat:sql, self.postId, tagId, self.updated];
    
    return YES;
}

- (BOOL)remove
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM %@ WHERE post_id=%d";
    
    [self.db executeUpdateWithFormat:sql, self.table, self.postId];
    [self.db executeQueryWithFormat:sql, self.tablePostToTag, self.postId];
    [self.db executeQueryWithFormat:sql, self.tablePostToMark, self.postId];
    
    return YES;
}

- (BOOL)removeAll
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"DELETE FROM %@";
    
    [self.db executeUpdate:[NSString stringWithFormat:sql, self.table]];
    [self.db executeQuery:[NSString stringWithFormat:sql, self.tablePostToTag]];
    [self.db executeQuery:[NSString stringWithFormat:sql, self.tablePostToMark]];
    
    return YES;
}


@end
