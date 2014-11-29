//
//  WBSettingViewController.m
//  WristBand
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBSettingViewController.h"
#import "WBSettingPersonalInfoCell.h"
#import "WBSettingSleepGoalCell.h"
#import "WBSettingSleepTipsCell.h"
#import "WBPersonalInfoViewController.h"

@interface WBSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    WBSettingSleepGoalCell *sleepGoalCell;
    WBSettingSleepTipsCell *sleepTipsCell;
}

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation WBSettingViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(33,39,40)];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dark_navigation_bar"] forBarMetrics:UIBarMetricsDefault];
    
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = [UIColor blackColor];
//    [self.navigationController.navigationBar addSubview:lineView];
//    [lineView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(42.5f, 0.0f, 0.0f, 0.0f)];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:17.0f];
    label.textColor = [UIColor whiteColor];
    label.text = @"User";
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    _tableView = [[UITableView alloc] init];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    [_tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    sleepGoalCell = [[WBSettingSleepGoalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sleepGoalCellIdentifier"];
    
    sleepTipsCell = [[WBSettingSleepTipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sleepTipsCellIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonClick {
    [self.navigationController.containViewController transitionFromViewController:self.navigationController toViewController:self.navigationController.containViewController.lastViewController duration:0.55f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{

    } completion:^(BOOL finished) {
        [self.navigationController removeFromParentViewController];
        [self.navigationController.view removeFromSuperview];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        WBPersonalInfoViewController *viewController = [[WBPersonalInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *imageCellIdentifier = @"imageCellIdentifier";
    static NSString *personalInfoCellIdentifier = @"personalInfoCellIdentifier";
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:imageCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_acount"]];
            [cell.contentView addSubview:imageView];
            [imageView autoSetDimensionsToSize:CGSizeMake(42.0f, 43.0f)];
            [imageView autoCenterInSuperview];
        }
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:personalInfoCellIdentifier];
        if (!cell) {
            cell = [[WBSettingPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personalInfoCellIdentifier];
        }
    } else if (indexPath.section == 2) {
        cell = sleepGoalCell;
    } else if (indexPath.section == 3) {
        cell = sleepTipsCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 73.0f;
    }
    
    if (indexPath.section == 1) {
        return 60.0f;
    }
    
    if (indexPath.section == 2) {
        [sleepGoalCell configCell];
        return [sleepGoalCell cellHeight];
    }
    
    if (indexPath.section == 3) {
        [sleepTipsCell configCell];
        return [sleepTipsCell cellHeight];
    }
    
    return 40.0f;
}

@end
