//
//  DiskCache.h
//  
//
//  Created by  on 13-10-28.
//  Copyright (c) 2013年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiskCache : NSObject
{
    NSString *_imageCachePath;
}

+ (id)getInstance;
- (void)initCache;
- (void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath;


@end
