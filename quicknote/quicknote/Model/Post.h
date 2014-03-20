//
//  Post.h
//  quicknote
//
//  Created by hello on 14-3-11.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "Tag.h"

//#define USE_DICT

@interface Post : Model

@property (atomic, retain) NSString *table;

// we can make a full ActiveRecord model
// but this time not necessary
// https://github.com/AlexDenisov/iActiveRecord

@property (atomic, retain) NSString *tableTag;
@property (atomic, retain) NSString *tableMark;
@property (atomic, retain) NSString *tablePostToTag;
@property (atomic, retain) NSString *tablePostToMark;

#ifdef USE_DICT
@property (atomic, retain) NSMutableDictionary *fieldDictionary;
#endif

@property (atomic, assign) NSInteger postId;
@property (atomic, retain) NSString *name;
@property (atomic, retain) NSString *nameIndex;
@property (atomic, retain) NSString *description;
@property (atomic, retain) NSString *location;
@property (atomic, retain) NSString *address;
@property (atomic, retain) NSString *longitude;
@property (atomic, retain) NSString *latitude;
@property (atomic, retain) NSString *watermark;
@property (atomic, assign) NSInteger created;
@property (atomic, assign) NSInteger updated;

@property (atomic, retain) NSMutableArray *tagArray;

- (BOOL)fetch:(NSMutableArray *)postArray Filter:(NSString *)filter Order:(NSString *)order Page:(NSInteger)page PageSize:(NSInteger)pageSize;

- (BOOL)add;
- (BOOL)update;
- (BOOL)remove;

- (BOOL)updateTag:(NSArray *)tagArray;

@end
