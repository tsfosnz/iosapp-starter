//
//  Post.m
//  Pixcell8
//
//  Created by  on 13-10-27.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "Image.h"

@implementation Image


- (BOOL)changeUploadStatus:(NSString *)status
{
    
    if (![self.db open]) {
        return NO;
    }
    
    [self.db executeUpdate:@"DELETE FROM setting WHERE name='image_upload_update'"];
    [self.db executeUpdate:@"INSERT INTO setting (name, value) VALUES ('image_upload_update', '1')"];
    
    
    AppConfig *config = [AppConfig getInstance];
    
    config.userIsLogin = 1;
    config.imageIsUploaded = 1;
    
    return YES;
    
}


@end
