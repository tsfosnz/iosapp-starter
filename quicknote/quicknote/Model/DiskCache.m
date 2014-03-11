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
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
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
        //NSLog(@"Create directory error: %@", error);
    }
}

- (NSString *)saveImage:(UIImage *)image fileName: (NSString *)fileName
{
    
    NSString *pngPath = [NSString stringWithFormat:@"%@/%@", _imageCachePath, fileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:pngPath isDirectory:NO]) {
        
        return pngPath;
    }
    
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
    
    
    //if ([[NSFileManager defaultManager] fileExistsAtPath:pngPath]) {
        
    
        
#if false
        // Let's check to see if files were successfully written...
        
        // Create file manager
        NSError *error;
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        // Point to Document directory
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        // Write out the contents of home directory to console
        NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
#endif

    //}
    
    return pngPath;
    
}

- (NSString *)getImagePath:(NSString *)fileName
{
    
    NSString *pngPath = [NSString stringWithFormat:@"%@/%@", _imageCachePath, fileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:pngPath isDirectory:NO]) {
        
        return pngPath;
    }
    
    return nil;
    
}

- (UIImage *)getImage:(NSString *)fileName
{
    NSString *pngPath = [NSString stringWithFormat:@"%@/%@", _imageCachePath, fileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:pngPath isDirectory:NO]) {
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngPath]];
        return image;
    }
    
    return nil;
}

@end
