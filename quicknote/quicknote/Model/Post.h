//
//  Post.h
//  quicknote
//
//  Created by hello on 14-3-11.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface Post : Model

@property (atomic, retain) NSString *table;

// we can make a full ActiveRecord model
// but this time not necessary
// https://github.com/AlexDenisov/iActiveRecord

@property (atomic, retain) NSMutableArray *fieldArray;
@property (atomic, retain) NSMutableDictionary *fieldValueDict;

@property (atomic, assign) NSInteger postId;
@property (atomic, retain) NSString *name;
@property (atomic, retain) NSString *description;


- (BOOL)add;
- (BOOL)remove;

@end
