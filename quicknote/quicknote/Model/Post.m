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
        self.fieldArray = [[NSMutableArray alloc] initWithArray:@[@"post_id", @"name", @"description"]];
        //self.fieldValueDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
    
}


- (BOOL)add
{
    if (!self.db) {
        return NO;
    }
    
    [self.db executeUpdateWithFormat:@"INSERT INTO %@ (post_id, name, description) VALUES (%d, %@, %@)", self.table, self.postId, self.name, self.description];
    
    return YES;
}

- (BOOL)remove
{
    
    return YES;
}


@end
