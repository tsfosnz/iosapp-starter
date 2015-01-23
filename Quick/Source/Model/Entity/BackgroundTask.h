//
//  BackgroundTask.h
//  Gaje
//
//  Created by hello on 14-12-31.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "Model.h"

@interface BackgroundTask : NSObject

@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property (nonatomic) NSMutableArray *data;

@property (nonatomic) UIView *view;
@property (nonatomic) UILabel *messageLabel;

+ (id)getInstance;
- (void)initTask;

@end
