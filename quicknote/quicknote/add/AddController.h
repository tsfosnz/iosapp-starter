//
//  AddController.h
//  quicknote
//
//  Created by hello on 14-4-9.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Post;

@interface AddController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableDictionary *layoutDefinition;

@end
