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
}

@end

@implementation WBTotalSleepTimeCell

- (instancetype)init {
    self = [super init];
    if (self) {        
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 5.0f;
        [self.contentView addSubview:backView];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [backView autoSetDimension:ALDimensionHeight toSize:80.0f];
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_total_sleep_time"]];
        [backView addSubview:imageView];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [imageView autoSetDimensionsToSize:CGSizeMake(43.0f, 43.0f)];
        
        sleepTimeLabel = [[UILabel alloc] init];
        sleepTimeLabel.backgroundColor = [UIColor clearColor];
        sleepTimeLabel.font = [UIFont systemFontOfSize:15.0f];
        sleepTimeLabel.textColor = RGB(87,104,106);
        [backView addSubview:sleepTimeLabel];
        [sleepTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [sleepTimeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:7.0f];
        
        progressBackView = [[UIView alloc] init];
        progressBackView.backgroundColor = RGB(214,218,219);
        [backView addSubview:progressBackView];
        [progressBackView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imageView];
        [progressBackView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:7.0f];
        [progressBackView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [progressBackView autoSetDimension:ALDimensionHeight toSize:14.0f];
        
        progressView = [[UIView alloc] init];
        progressView.backgroundColor = RGB(97,159,189);
        [backView addSubview:progressView];
		
        sleepDescLabel = [[UILabel alloc] init];
        sleepDescLabel.backgroundColor = [UIColor clearColor];
        sleepDescLabel.font = [UIFont systemFontOfSize:12.0f];
        sleepDescLabel.textColor = [UIColor lightGrayColor];
        sleepDescLabel.text = NSLocalizedString(@"Total sleep time", nil);
        [backView addSubview:sleepDescLabel];
        [sleepDescLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:progressBackView withOffset:5.0f];
        [sleepDescLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:7.0f];
        
        goalLabel = [[UILabel alloc] init];
        goalLabel.backgroundColor = [UIColor clearColor];
        goalLabel.font = [UIFont systemFontOfSize:12.0f];
        goalLabel.textColor = [UIColor lightGrayColor];
        [backView addSubview:goalLabel];
        [goalLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:progressBackView withOffset:5.0f];
        [goalLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    }
    
    return self;
    
}

- (void)configCell {
    sleepTimeLabel.text = self.sleepInfo.totalSleepTimeString;
    goalLabel.text = self.sleepInfo.goalPercentString;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
	
	CGRect frame = progressBackView.frame;
	frame.size.width = progressBackView.width * (self.sleepInfo.goalPercent > 1.0f ? 1.0f : self.sleepInfo.goalPercent);
    progressView.frame = frame;
    
}

- (CGFloat)cellHeight {
    return backView.bottom + 0.0f;
}

@end
