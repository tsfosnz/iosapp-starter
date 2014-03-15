//
//  Tag.h
//  quicknote
//
//  Created by hello on 14-3-15.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "Model.h"

@interface Tag : Model

@property (atomic, retain) NSString *table;
@property (atomic, assign) NSInteger tagId;
@property (atomic, retain) NSString *name;
@property (atomic, retain) NSString *nameIndex;

- (BOOL)fetch:(NSMutableArray *)postArray Filter:(NSString *)filter Order:(NSString *)order Page:(NSInteger)page PageSize:(NSInteger)pageSize;
- (BOOL)add;
- (BOOL)update;
- (BOOL)remove;

@end
