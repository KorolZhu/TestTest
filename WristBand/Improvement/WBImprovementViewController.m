//
//  WBImprovementViewController.m
//  WristBand
//
//  Created by zhuzhi on 14/11/3.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBImprovementViewController.h"

@interface WBImprovementViewController ()
{
    UIImageView *leftImageView;
    UIImageView *rightImageView;
    UILabel *tipTitleLabel;
    UILabel *tipDescLabel;
}

@property (nonatomic,strong)UINavigationBar *navigationBar;
@property (nonatomic,strong)UIScrollView *scrollView;

@end
@implementation WBImprovementViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(215,222,223);
    
    _navigationBar = [[UINavigationBar alloc] init];
    [self.view addSubview:_navigationBar];
    [_navigationBar autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_navigationBar autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_navigationBar autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_navigationBar autoSetDimension:ALDimensionHeight toSize:64.0f];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(146,162,163);
    [_navigationBar addSubview:lineView];
    [lineView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(62.5f, 0.0f, 0.0f, 0.0f)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [_navigationBar pushNavigationItem:navigationItem animated:YES];
    
    navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_idea"]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
    [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = nil;
    backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    navigationItem.leftBarButtonItem = backButton;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    
    [_scrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_navigationBar];
    [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_scrollView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
    leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_icon_fitness"]];
    [_scrollView addSubview:leftImageView];
    leftImageView.left = 10.0f;
    leftImageView.top = 10.0f;
    
    rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_icon_sheep"]];
    [_scrollView addSubview:rightImageView];
    [rightImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [rightImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftImageView withOffset:80.0f];
    
    tipTitleLabel = [[UILabel alloc] init];
    tipTitleLabel.backgroundColor = [UIColor clearColor];
    tipTitleLabel.textColor = RGB(211,89,15);
    tipTitleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    [_scrollView addSubview:tipTitleLabel];
    [tipTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:leftImageView withOffset:30.0f];
    [tipTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    
    tipDescLabel = [[UILabel alloc] init];
    tipDescLabel.numberOfLines = 0;
    tipDescLabel.backgroundColor = [UIColor clearColor];
    tipDescLabel.textColor = [UIColor blackColor];
    tipDescLabel.font = [UIFont systemFontOfSize:15.0f];
    [_scrollView addSubview:tipDescLabel];
    [tipDescLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipTitleLabel withOffset:30.0f];
    [tipDescLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [tipDescLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withOffset:-10.0f];

    
    tipTitleLabel.text = NSLocalizedString(@"Exercise regularly", nil);
    tipDescLabel.text = NSLocalizedString(@"Aerobic exercise in the afternoon or at least 3 hours efore going to bed is good for sleep", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)backClick {
    [self.containViewController transitionFromViewController:self toViewController:self.containViewController.lastViewController duration:0.55f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }];
}

@end
