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
#import "WBConnectDeviceView.h"
#import "WBMeasuringView.h"

@interface WBMainViewController ()<UIScrollViewDelegate,WBConnectDeviceViewDelegate>

@property (nonatomic,strong)WBConnectDeviceView *connectDeviceView;
@property (nonatomic,strong)NSLayoutConstraint *topConstraint;

@property (nonatomic,strong)WBMeasuringView *measuringView;

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
    self.mainView.navigationController = self.navigationController;
    [_pagingScrollView addSubview:self.mainView];
    [self.mainView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.mainView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.mainView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_pagingScrollView];
    [self.mainView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_pagingScrollView];
    
    _connectDeviceView = [[WBConnectDeviceView alloc] init];
    _connectDeviceView.delegate = self;
    [_connectDeviceView.startSleepingButton addTarget:self action:@selector(startSleepingClick) forControlEvents:UIControlEventTouchUpInside];
    [_connectDeviceView.cancelButton addTarget:self action:@selector(cancelConnectClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_connectDeviceView];
    _topConstraint = [_connectDeviceView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:IPHONE_HEIGHT - 43.0f];
    [_connectDeviceView autoSetDimension:ALDimensionHeight toSize:IPHONE_HEIGHT + 43.0f + 64.0f];
//    _measuringView = [[WBMeasuringView alloc] init];
//    [self.navigationController.view addSubview:_measuringView];
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

#pragma mark - connect device

- (void)startSleepingClick {
    self.topConstraint.constant = -43.0f;
    [UIView animateWithDuration:0.35f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.navigationController.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }
     ];
}

- (void)cancelConnectClick {
    self.topConstraint.constant =  IPHONE_HEIGHT - 43.0f;
    [UIView animateWithDuration:0.35f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.navigationController.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                     }
     ];
}

- (void)connectDeviceViewDidConnected:(WBConnectDeviceView *)view {
    if (!_measuringView) {
        _measuringView = [[WBMeasuringView alloc] init];
        [self.navigationController.view addSubview:_measuringView];
        
    }
}

@end
