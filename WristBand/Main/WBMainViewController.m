//
//  WBMainViewController.m
//  WristBand
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBMainViewController.h"
#import "WBSettingViewController.h"
#import "WBMainView.h"

@interface WBMainViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *pagingScrollView;
@property (nonatomic,strong)WBMainView *mainView;

@end

@implementation WBMainViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(215,222,223);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon_user"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(userSettingClick) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    _pagingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.alwaysBounceHorizontal = YES;
    _pagingScrollView.directionalLockEnabled = YES;
    _pagingScrollView.delegate = self;
    _pagingScrollView.showsHorizontalScrollIndicator = NO;
    _pagingScrollView.showsVerticalScrollIndicator = NO;
    _pagingScrollView.backgroundColor = RGB(215,222,223);
    [self.view addSubview:_pagingScrollView];
    
    self.mainView = [[WBMainView alloc] init];
    [_pagingScrollView addSubview:self.mainView];
    [self.mainView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.mainView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.mainView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_pagingScrollView];
    [self.mainView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_pagingScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userSettingClick {
    WBSettingViewController *settingViewController = [[WBSettingViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

@end
