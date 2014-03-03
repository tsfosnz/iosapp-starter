//
//  MainController.m
//  quicknote
//
//  Created by hello on 14-3-4.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "MainController.h"

@interface MainController ()

@end

@implementation MainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setup];
}

- (void)setup
{
    
    
#if true
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UIViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"home_init"];
    
    [self addChildViewController:home];
    
    storyboard = [UIStoryboard storyboardWithName:@"Camera" bundle:nil];
    UIViewController *camera = [storyboard instantiateViewControllerWithIdentifier:@"camera_init"];
    
    [self addChildViewController:camera];
    
    storyboard = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    UIViewController *setting = [storyboard instantiateViewControllerWithIdentifier:@"setting_init"];
    
    [self addChildViewController:setting];
#endif
    
    NSArray *titles = @[@"Home", @"Capture", @"Setting"];
    for (int i = 0; i < [self.viewControllers count]; ++i) {
        UIViewController *controller = [self.viewControllers objectAtIndex:i];
        //[controller.tabBarItem setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab_icon%d", i]]];
        [controller.tabBarItem setTitle:[titles objectAtIndex:i]];
    }
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
