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
    
    NSString *sql = @"INSERT INTO %@ (name, name_index, description, location, address, longitude, latitude, watermark, created, updated) VALUES (%@, %@, %@, %@, %@, %@, %@, %@, %ld, %ld)";
    
    [self.db executeUpdateWithFormat:sql, self.name, self.nameIndex, self.description, self.location, self.address, self.longitude, self.latitude, self.watermark, self.created, self.updated];
    
    self.postId = (NSInteger)[self.db lastInsertRowId];
    
    return YES;
}

- (BOOL)update
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"UPDATE %@ SET name=%@, name_index=%@, description=%@, location=%@, address=%@, longitude=%@, latitude=%@, watermark=%@, created=%ld, updated=%ld WHERE post_id=%ld";
    
    [self.db executeUpdateWithFormat:sql, self.name, self.nameIndex, self.description, self.location, self.address, self.longitude, self.latitude, self.watermark, self.created, self.updated, self.postId];
    
    return YES;
}

- (BOOL)updateTag:(NSArray *)tagArray
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"UPDATE %@ SET post_id=%ld, tag_id=%ld, updated=%ld WHERE post_id=%ld";
    
    //[self.db executeUpdateWithFormat:sql, self.postId, tagId, self.updated];
    
    return YES;
}

- (BOOL)updateMark
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"UPDATE %@ SET post_id=%ld, mark_id=%ld, updated=%ld WHERE post_id=%ld";
    
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
    
    return YES;
}


@end
