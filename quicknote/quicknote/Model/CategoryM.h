//
//  CategoryModel.h
//  quicknote
//
//  Created by hello on 14-3-21.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "Model.h"

// as Category is a reversed keyword...

@interface CategoryM : Model

@property (atomic, assign) NSInteger categoryId;
@property (atomic, retain) NSString *name;
@property (atomic, retain) NSString *nameIndex;
@property (atomic, assign) NSInteger level;
@property (atomic, assign) NSInteger sort;
@property (atomic, retain) NSString *family;

- (BOOL)fetch:(NSMutableArray *)categoryArray Filter:(NSString *)filter Order:(NSString *)order Page:(NSInteger)page PageSize:(NSInteger)pageSize;

- (BOOL)add;
- (BOOL)update;
- (BOOL)remove;

+ (NSString *)table;

@end
