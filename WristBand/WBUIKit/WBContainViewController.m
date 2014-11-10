//
//  WBContainViewController.m
//  WristBand
//
//  Created by zhuzhi on 14/11/8.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBContainViewController.h"
#import "WBMainViewController.h"

@interface WBContainViewController ()

@property (nonatomic,strong)WBMainViewController *mainViewController;

@end

@implementation WBContainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mainViewController = [[WBMainViewController alloc] init];
    [self addChildViewController:_mainViewController];
    _mainViewController.view.frame = self.view.bounds;
    _mainViewController.view.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_mainViewController.view]; //2
    [_mainViewController didMoveToParentViewController:self];
    
    self.viewControllers = [NSArray arrayWithObject:_mainViewController];
    self.currentViewController = _mainViewController;
}

- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {
    [super transitionFromViewController:fromViewController toViewController:toViewController duration:duration options:options animations:animations completion:completion];
    
    if ([self.viewControllers containsObject:toViewController]) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.viewControllers];
        [arr removeObject:fromViewController];
        self.viewControllers = [NSArray arrayWithArray:arr];
    } else {
        self.viewControllers = [self.viewControllers arrayByAddingObject:toViewController];
    }
    
    
    self.currentViewController = toViewController;
    if (self.viewControllers.count >= 2) {
        self.lastViewController = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    }
}

@end
