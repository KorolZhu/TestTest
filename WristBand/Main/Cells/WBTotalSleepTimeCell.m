//
//  WBTotalSleepTimeCell.m
//  WristBand
//
//  Created by zhuzhi on 14/11/2.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBTotalSleepTimeCell.h"

@interface WBTotalSleepTimeCell ()
{
    UIView *backView;
    UIImageView *imageView;
    UILabel *sleepTimeLabel;
    UIView *progressBackView, *progressView;
    UILabel *sleepDescLabel, *goalLabel;
    
    NSLayoutConstraint *progressLabelWidthConstraint;
}

@end

@implementation WBTotalSleepTimeCell

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, 0.0f)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 5.0f;
        [self.contentView addSubview:backView];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [backView autoSetDimension:ALDimensionHeight toSize:80.0f];
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_total_sleep_time"]];
        [self.contentView addSubview:imageView];
        [imageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:backView withOffset:10.0f];
        [imageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:backView];
        
        sleepTimeLabel = [[UILabel alloc] init];
        sleepTimeLabel.backgroundColor = [UIColor clearColor];
        sleepTimeLabel.font = [UIFont systemFontOfSize:15.0f];
        sleepTimeLabel.textColor = RGB(87,104,106);
        [self.contentView addSubview:sleepTimeLabel];
        [sleepTimeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:backView withOffset:10.0f];
        [sleepTimeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:7.0f];
        
        progressBackView = [[UIView alloc] init];
        progressBackView.backgroundColor = RGB(214,218,219);
        [self.contentView addSubview:progressBackView];
        [progressBackView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imageView];
        [progressBackView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:7.0f];
        [progressBackView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:backView withOffset:-10.0f];
        [progressBackView autoSetDimension:ALDimensionHeight toSize:14.0f];
        
        progressView = [[UIView alloc] init];
        progressView.backgroundColor = RGB(97,159,189);
        [self.contentView addSubview:progressView];
        [progressView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:progressBackView];
        [progressView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:progressBackView];
        [progressView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:progressBackView];
        progressLabelWidthConstraint = [progressView autoSetDimension:ALDimensionWidth toSize:20.0f];
        
        sleepDescLabel = [[UILabel alloc] init];
        sleepDescLabel.backgroundColor = [UIColor clearColor];
        sleepDescLabel.font = [UIFont systemFontOfSize:12.0f];
        sleepDescLabel.textColor = [UIColor lightGrayColor];
        sleepDescLabel.text = NSLocalizedString(@"Total sleep time", nil);
        [self.contentView addSubview:sleepDescLabel];
        [sleepDescLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:progressBackView withOffset:5.0f];
        [sleepDescLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:7.0f];
        
        goalLabel = [[UILabel alloc] init];
        goalLabel.backgroundColor = [UIColor clearColor];
        goalLabel.font = [UIFont systemFontOfSize:12.0f];
        goalLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:goalLabel];
        [goalLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:progressBackView withOffset:5.0f];
        [goalLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:backView withOffset:-10.0f];
    }
    
    return self;
    
}

- (void)configCell {
    sleepTimeLabel.text = @"7 h 10 min";
    progressLabelWidthConstraint.constant = 60.0f;
    goalLabel.text = @"102% of goal";
}

- (CGFloat)cellHeight {
    [self configCell];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    return backView.bottom + 0.0f;
}

@end
