//
//  WBSettingPersonalInfoCell.m
//  WristBand
//
//  Created by zhuzhi on 14/11/3.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBSettingPersonalInfoCell.h"

@implementation WBSettingPersonalInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor clearColor];
        backView.layer.borderColor = [[UIColor whiteColor] CGColor];
        backView.layer.borderWidth = 0.5f;
        backView.layer.cornerRadius = 6.0f;
        [self.contentView addSubview:backView];
        [backView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0f, 10.0f, 5.0f, 10.0f)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_acount_edit_acount"]];
        [backView addSubview:imageView];
        [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.text = NSLocalizedString(@"Personal info", nil);
        [backView addSubview:label];
        [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:13.0f];
        
        UIImageView *arrowRightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_right_white"]];
        [backView addSubview:arrowRightView];
        [arrowRightView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [arrowRightView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    
    return self;
}

@end
