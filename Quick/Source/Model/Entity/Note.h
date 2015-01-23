//
//  Note.h
//  Gaje
//
//  Created by hello on 14-7-19.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Model.h"
#import "Global.h"
#import "AFNetworking.h"

@interface Note : Model

@property (atomic, assign) NSInteger *noteId;
@property (atomic, retain) NSString *noteUUID;
@property (atomic, retain) NSString *name;
@property (atomic, retain) NSString *desc;
@property (atomic, assign) BOOL selected;

+ (id)getInstance;
- (BOOL)fetchList:(NSMutableArray *)noteArray;

@end