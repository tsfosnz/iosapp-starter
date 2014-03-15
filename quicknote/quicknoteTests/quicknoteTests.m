//
//  quicknoteTests.m
//  quicknoteTests
//
//  Created by hello on 14-3-1.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Post.h"

@interface quicknoteTests : XCTestCase

@end

@implementation quicknoteTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    
    Tag *tag = [[Tag alloc] init];
    
#if true
    for (int i = 0; i < 100; ++i) {
        tag.name = [NSString stringWithFormat:@"%@%d", @"tag_", i];
        [tag add];
    }
#endif
    
    Post *post = [[Post alloc] init];
    
    for (int i = 0; i < 100; ++i) {
        post.name = [NSString stringWithFormat:@"%@%d",@"post_",i];
        post.created = [[NSDate date] timeIntervalSince1970];
        post.updated = post.created;
        [post add];
    }
    
#if false
    NSMutableArray *tagArray;

    tagArray = [[NSMutableArray alloc] init];
    
    [tag fetch:tagArray Filter:@"TRUE" Order:@"tag_id DESC" Page:0 PageSize:200];
    
    NSLog(@"tags = %@", tagArray);
#endif
    
    
    //Post *post = [[Post alloc] init];
    
    //post.name
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
