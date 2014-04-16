//
//  Post.m
//  quicknote
//
//  Created by hello on 14-3-11.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "Post.h"
#import "Image.h"
#import "Tag.h"
#import "CategoryM.h"
#import "PostToCategory.h"
#import "PostToImage.h"
#import "PostToTag.h"

@implementation Post

- (id)init
{
    
    self = [super init];
    
    if (self) {
        self.table = @"post";
        
        self.tablePostToTag = [PostToTag table];
        self.tablePostToImage = [PostToImage table];
        self.tablePostToCategory = [PostToCategory table];
        
        self.tableTag = [Tag table];
        self.tableImage = [Image table];
        self.tableCategory = [CategoryM table];
        
#ifdef USE_DICT
        self.fieldDictionary = [[NSMutableDictionary alloc] init];
        
        NSArray *fieldArray = @[
            @[@"post_id", @"int"],
            @[@"image", @"text"],
            @[@"name", @"text"],
            @[@"name_index", @"text"],
            @[@"description", @"text"],
            @[@"location", @"text"],
            @[@"address", @"text"],
            @[@"longitude", @"text"],
            @[@"latitude", @"text"],
            @[@"watermark", @"text"],
            @[@"created", @"int"],
            @[@"updated", @"int"]];
        
        
        for (NSArray *field in fieldArray) {
            
            if ([[field objectAtIndex:1] isEqualToString:@"int"]) {
                [self.fieldDictionary setObject:[NSNumber numberWithInteger:0] forKey:[field objectAtIndex:0]];
            }
            
            if ([[field objectAtIndex:1] isEqualToString:@"text"]) {
               [self.fieldDictionary setObject:@"" forKey:[field objectAtIndex:0]];
            }
        }
#endif
        
    }
    
    return self;
    
}

- (BOOL)fetch:(NSMutableArray *)postArray Filter:(NSString *)filter Order:(NSString *)order Page:(NSInteger)page PageSize:(NSInteger)pageSize
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"SELECT * FROM %@ WHERE %@ ORDER BY %@ LIMIT %d, %d";
    
    sql = [NSString stringWithFormat:sql, self.table, filter, order, page * pageSize, pageSize];
    
    FMResultSet *result = [self.db executeQuery:sql];
    
    while ([result next]) {
        
        Post *post = [[Post alloc] init];
        
        post.postId = [result intForColumn:@"post_id"];
        post.name = [result stringForColumn:@"name"];
        
        [postArray addObject:post];
        
        post = nil;
        
    }
    
    for (Post *post in postArray) {
        
        if (!post.imageArray) {
            post.imageArray = [[NSMutableArray alloc] init];
        }
        
        [post fetchTags:post.tagArray Order:@"image_id ASC" Page:0 PageSize:100];
        
        NSLog(@"post = %@", post.name);
        
    }
    
    for (Post *post in postArray) {
    
        if (!post.tagArray) {
            post.tagArray = [[NSMutableArray alloc] init];
        }
    
        [post fetchTags:post.tagArray Order:@"tag_id ASC" Page:0 PageSize:100];
        
        NSLog(@"post = %@", post.name);
        
    }
    
    return YES;
}

- (BOOL)fetchImages:imageArray Order:(NSString *)order Page:(NSInteger)page PageSize:(NSInteger)pageSize
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"SELECT t.* FROM %@ AS t INNER JOIN %@ AS pt ON t.image_id=pt.image_id WHERE pt.post_id=%d ORDER BY %@ LIMIT %d, %d";
    
    sql = [NSString stringWithFormat:sql, self.tableImage, self.tablePostToImage, self.postId, order, page * pageSize, pageSize];
    
    FMResultSet *result = [self.db executeQuery:sql];
    
    while ([result next]) {
        
        Image *image = [[Image alloc] init];
        
        image.imageId = [result intForColumn:@"image_id"];
        image.name = [result stringForColumn:@"name"];
        image.description = [result stringForColumn:@"description"];
        image.watermark = [result stringForColumn:@"watermark"];
        image.created = [result intForColumn:@"created"];
        image.updated = [result intForColumn:@"updated"];
        
        [imageArray addObject:image];
        
    }
    
    
    return YES;
}

- (BOOL)fetchTags:tagArray Order:(NSString *)order Page:(NSInteger)page PageSize:(NSInteger)pageSize
{
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = @"SELECT t.* FROM %@ AS t INNER JOIN %@ AS pt ON t.tag_id=pt.tag_id WHERE pt.post_id=%d ORDER BY %@ LIMIT %d, %d";
    
    sql = [NSString stringWithFormat:sql, self.tableTag, self.tablePostToTag, self.postId, order, page * pageSize, pageSize];
    
    FMResultSet *result = [self.db executeQuery:sql];
    
    while ([result next]) {
        
        Tag *tag = [[Tag alloc] init];
        
        tag.tagId = [result intForColumn:@"tag_id"];
        tag.name = [result stringForColumn:@"name"];
        
        [tagArray addObject:tag];
        
    }
    
    
    return YES;
}

#ifdef USE_DICT
- (BOOL)setValue:(NSString *)key Value:(id)value
{
    [self.fieldDictionary setObject:value forKey:key];
    
    return YES;
}
#endif

- (BOOL)add
{
    if (!self.db) {
        return NO;
    }
    
#ifdef USE_DICT
    
    // looks very clean, but bad metaphor in value input
    // even use Key-Value Coding, still not good
    
    NSString *sql = @"INSERT INTO %@ VALUES (:name, :name_index, :description, :location, :address, :longitude, :latitude, :watermark, :created, :updated)";
    sql = [NSString stringWithFormat:sql, self.table];
    
    [self.db executeUpdate:sql withParameterDictionary:self.fieldDictionary];
    
#else
    
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
#endif
    
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

+ (NSString *)table
{
    return @"post";
}

//=================

- (BOOL)layoutAttributesInAdd:(NSMutableDictionary *)layout
{

    // name, value type
    
    NSString *sql = @"SELECT * FROM postmeta WHERE postmeta ";
    self.db executeQuery:<#(NSString *), ...#>
    
    return YES;
}

@end
