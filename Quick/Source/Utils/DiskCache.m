//
//  DiskCache.m
//  
//
//  Created by  on 13-10-28.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "DiskCache.h"

@implementation DiskCache

+ (id)getInstance {
    static DiskCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)initCache {
    NSString *document = NSTemporaryDirectory();
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/cache/image", document]]) {
        _imageCachePath = [NSString stringWithFormat:@"%@/cache/image", document];
        return;
    }
    
    [self createDirectory:@"cache" atFilePath:document];
    [self createDirectory:@"image" atFilePath:[NSString stringWithFormat:@"%@/%@", document, @"cache"]];
    
    _imageCachePath = [NSString stringWithFormat:@"%@/cache/image", document];
}


- (void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath
{
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        // NSLog(@"Create directory error: %@", error);
    }
}


// add image to cache, and get its file path

- (NSString *)addImage:(UIImage *)image fileName: (NSString *)fileName
{
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", _imageCachePath, fileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath isDirectory:NO]) {
        
        return filePath;
    }

    [UIImageJPEGRepresentation(image, 1) writeToFile:filePath atomically:YES];
    //[UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    
    return filePath;
}

- (UIImage *)getImage:(NSString *)fileName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", _imageCachePath, fileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:filePath isDirectory:NO]) {
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
        return image;
    }
    
    return nil;
}

- (NSString *)getImagePath:(NSString *)fileName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", _imageCachePath, fileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:filePath isDirectory:NO]) {
        
        return filePath;
    }
    
    return nil;
}


@end
