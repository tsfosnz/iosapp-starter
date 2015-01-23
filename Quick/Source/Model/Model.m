//
//  Model.m
//  Pixcell8
//
//  Created by  on 14-2-8.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "Model.h"

@implementation Model

- (id)init {
    
    self = [super init];
    if (self) {
        AppConfig *config = [AppConfig getInstance];
        self.db = [FMDatabase databaseWithPath:config.dbPath];
        
    }
    return self;
}

- (NSString *)escape:(NSString *)string
{
    
    if (string == nil || (NSNull *)string == [NSNull null] || string == NULL) {
        string = @"";
    }
    
    return string;
}

- (NSString*)MD5:(NSString *)string
{
    // Create pointer to the string as UTF8
    const char *ptr = [string UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (NSString *)getToken
{
    
    NSDate *date = [NSDate date];
    NSInteger timestamp = [date timeIntervalSince1970];
    
    NSString *hash = [NSString stringWithFormat:@"%@%d", API_SECRECT, timestamp];
    return [NSString stringWithFormat:@"%@+%d", [self MD5:hash], timestamp];
}

- (NSString *)stringFromTimestamp:(NSInteger)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.timeZone = [NSTimeZone defaultTimeZone];
    formatter.dateStyle = NSDateFormatterLongStyle;
    
    return [formatter stringFromDate:date];

}

@end
