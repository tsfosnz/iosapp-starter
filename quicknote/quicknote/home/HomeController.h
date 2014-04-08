//
//  HomeController.h
//  quicknote
//
//  Created by hello on 14-4-8.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeController : UIViewController

@property (retain) IBOutlet UITableView *tableView;
@property (retain) IBOutlet UIToolbar *bottomBar;

@property (retain) IBOutletCollection(UIButton) NSArray *bottomBarButtonCollection;

@end
