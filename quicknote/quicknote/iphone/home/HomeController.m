//
//  HomeController.m
//  quicknote
//
//  Created by hello on 14-4-8.
//  Copyright (c) 2014年 hellomaya. All rights reserved.
//

#import "HomeController.h"

@interface HomeController ()

@end

@implementation HomeController

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
    NSArray *buttonNameArray = @[@"Search", @"Add", @"Sort"];
    for (UIButton *button in self.bottomBarButtonCollection) {
        NSLog(@"button.tag = %ld", (long)button.tag);
        [button setTitle:[buttonNameArray objectAtIndex:button.tag] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onToolbarButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    }
}

- (IBAction)onToolbarButtonTouchDown:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Add" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"add_home"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
