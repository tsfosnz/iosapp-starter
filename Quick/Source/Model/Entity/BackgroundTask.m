//
//  BackgroundTask.m
//  Gaje
//
//  Created by hello on 14-12-31.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "BackgroundTask.h"
#import "Notification.h"
#import "Setting.h"

@implementation BackgroundTask

+ (id)getInstance {
    static BackgroundTask *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

- (void)initTask
{
    
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:5 * 60
                                                        target:self
                                                      selector:@selector(task)
                                                      userInfo:nil
                                                       repeats:YES];
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background handler called. Not running background tasks anymore.");
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    self.data = [[NSMutableArray alloc] init];
    Setting *model = [Setting getInstance];
    NSDictionary *data = [model getItem:@"notification_uuid"];
    
    if (data != nil && [data objectForKey:@"notification_uuid"]) {
     
        AppConfig *config = [AppConfig getInstance];
        config.notificationuuid = [data objectForKey:@"notification_uuid"];
    }
}

- (void)task
{
    
    Notification *n = [Notification getInstance];
    
    [n fetchList:self.data];    
}

- (BOOL)onCallback:(NSInteger)type
{
    NSLog(@"callback");
    
    if ([self.data count] > 0) {
        NSLog(@"%@", self.data);
        
        AppConfig *config = [AppConfig getInstance];
        Notification *notification = [self.data objectAtIndex:0];
        
        if ([notification.notificationuuid isEqualToString:config.notificationuuid]){
            return NO;
        }
        
        config.notificationuuid = notification.notificationuuid;
        
        Setting *model = [Setting getInstance];
        if (![model addItem:@"notification_uuid" Value:config.notificationuuid]) {
            [model updateItem:@"notification_uuid" Value:config.notificationuuid];
        };
        
        //NSLog(@"%@", [model getItem:@"notification_uuid"]);
        
        //[self.messageLabel setText:@"hello world"];
        //[[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.view];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:notification.desc delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    
    return NO;
}

@end
