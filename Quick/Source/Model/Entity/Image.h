//
//  Post.h
//  Pixcell8
//
//  Created by  on 13-10-27.
//  Copyright (c) 2013年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "Model.h"
#import "User.h"
#import "DiskCache.h"
#import "Comment.h"
#import "Brand.h"


@interface Image : Model

@property (atomic, assign) NSInteger imageId;
@property (atomic, retain) NSString *imageuuid;
@property (atomic, retain) NSString *useruuid;
@property (atomic, retain) NSString *username;
@property (atomic, retain) NSString *usertoken;
@property (atomic, retain) NSString *usericon;

@property (atomic, retain) NSString *name;
@property (atomic, retain) NSString *desc;
@property (atomic, retain) NSString *tags;
@property (atomic, assign) NSInteger height;
@property (atomic, assign) NSInteger width;

@property (atomic, retain) NSString *fileName;

@property (atomic, retain) NSString *url;
@property (atomic, retain) NSString *thumbnail;
@property (atomic, strong) NSString *thumbnailName;

@property (atomic, retain) NSString *created;
@property (atomic, retain) NSString *modified;
@property (assign) NSInteger isTracking;

// table relationship properties

@property (strong) NSString *commentuuid;
@property (strong) NSString *branderuuid;

@property (atomic, assign) NSInteger branderCount;
@property (atomic, strong) NSMutableArray *branderArray;
@property (atomic, assign) NSInteger enableBrandIt;
@property (atomic, assign) NSInteger brandIt;

// update

@property (assign) NSInteger status;

// accessory properties
@property (atomic, retain) UIProgressView *progress;

- (BOOL)changeUploadStatus:(NSString *)status;

@end
