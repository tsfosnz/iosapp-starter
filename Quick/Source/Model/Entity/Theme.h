//
//  Theme.h
//  Gaje
//
//  Created by hello on 14-7-2.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Model.h"
#import "Global.h"
#import "AFNetworking.h"

@interface Theme : Model

@property (atomic, assign) NSInteger *themeId;
@property (atomic, retain) NSString *themeUUID;
@property (atomic, retain) NSString *name;
@property (atomic, retain) NSString *desc;
@property (atomic, assign) BOOL selected;

+ (id)getInstance;
- (BOOL)fetchList:(NSMutableArray *)themeArray;

@end
