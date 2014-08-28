//
//  Image.h
//  quicknote
//
//  Created by hello on 14-3-20.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "Model.h"

@interface Image : Model

@property (atomic, assign) NSInteger imageId;
@property (atomic, retain) NSString *name;
@property (atomic, retain) NSString *nameIndex;
@property (atomic, retain) NSString *description;
@property (atomic, retain) NSString *watermark;
@property (atomic, assign) NSInteger created;
@property (atomic, assign) NSInteger updated;

+ (NSString *)table;

@end
