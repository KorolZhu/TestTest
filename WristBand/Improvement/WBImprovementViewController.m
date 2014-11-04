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

@end
@implementation WBImprovementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.view.backgroundColor = RGB(215,222,223);
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_idea"]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
    [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = nil;
    backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_icon_fitness"]];
    [self.view addSubview:leftImageView];
    leftImageView.left = 10.0f;
    leftImageView.top = 10.0f;
    
    rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_icon_sheep"]];
    [self.view addSubview:rightImageView];
    [rightImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [rightImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftImageView withOffset:80.0f];
    
    tipTitleLabel = [[UILabel alloc] init];
    tipTitleLabel.backgroundColor = [UIColor clearColor];
    tipTitleLabel.textColor = RGB(211,89,15);
    tipTitleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    [self.view addSubview:tipTitleLabel];
    [tipTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:leftImageView withOffset:30.0f];
    [tipTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    
    tipDescLabel = [[UILabel alloc] init];
    tipDescLabel.numberOfLines = 0;
    tipDescLabel.backgroundColor = [UIColor clearColor];
    tipDescLabel.textColor = [UIColor blackColor];
    tipDescLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:tipDescLabel];
    [tipDescLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipTitleLabel withOffset:30.0f];
    [tipDescLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [tipDescLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view withOffset:-10.0f];

    
    tipTitleLabel.text = NSLocalizedString(@"Exercise regularly", nil);
    tipDescLabel.text = NSLocalizedString(@"Aerobic exercise in the afternoon or at least 3 hours efore going to bed is good for sleep", nil);
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
