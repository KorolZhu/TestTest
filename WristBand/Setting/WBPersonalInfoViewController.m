//
//  WBPersonalInfoViewController.m
//  WristBand
//
//  Created by zhuzhi on 14/11/4.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBPersonalInfoViewController.h"

@implementation WBPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGB(33,39,40)];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.navigationItem.title = NSLocalizedString(@"Personal info", nil);

}

@end
