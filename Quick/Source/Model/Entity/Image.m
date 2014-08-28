//
//  Image.m
//  quicknote
//
//  Created by hello on 14-3-20.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "Image.h"

@implementation Image

- (id)init
{
    
    self = [super init];
    
    if (self) {
        self.table = @"image";
    }
    
    return self;
}

+ (NSString *)table
{
    return @"image";
}

@end
