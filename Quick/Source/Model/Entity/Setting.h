//
//  Setting.h
//  Gaje
//
//  Created by hello on 14-12-31.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Model.h"

@interface Setting : Model

+ (id)getInstance;

@property (atomic, strong) NSString *name;
@property (atomic, strong) NSString *value;

- (BOOL)addItem:(NSString *)key Value:(NSString *)value;
- (BOOL)updateItem:(NSString *)key Value:(NSString *)value;
- (BOOL)removeItem:(NSString *)key;

- (NSDictionary *)getItem:(NSString *)key;

@end
