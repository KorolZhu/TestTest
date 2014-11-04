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

@interface WBSettingViewController ()
{
    WBSettingSleepGoalCell *sleepGoalCell;
    WBSettingSleepTipsCell *sleepTipsCell;
}
@end

@implementation WBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGB(33,39,40)];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.navigationItem.title = NSLocalizedString(@"User", nil);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *sleepGoalCellIdentifier = @"sleepGoalCellIdentifier";
    static NSString *sleepTipsCellIdentifier = @"sleepTipsCellIdentifier";
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:imageCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellIdentifier];
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
        sleepGoalCell = [tableView dequeueReusableCellWithIdentifier:sleepGoalCellIdentifier];
        if (!sleepGoalCell) {
            sleepGoalCell = [[WBSettingSleepGoalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sleepGoalCellIdentifier];
        }
        cell = sleepGoalCell;
    } else if (indexPath.section == 3) {
        sleepTipsCell = [tableView dequeueReusableCellWithIdentifier:sleepGoalCellIdentifier];
        if (!sleepTipsCell) {
            sleepTipsCell = [[WBSettingSleepTipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sleepTipsCellIdentifier];
        }
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
