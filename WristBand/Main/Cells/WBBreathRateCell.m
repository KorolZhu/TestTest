//
//  WBBreathRateCell.m
//  WristBand
//
//  Created by zhuzhi on 14/11/21.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBBreathRateCell.h"

@interface WBBreathRateCell ()
{
    UIView *backView;
    UIImageView *imageView;
    UILabel *breathsRateLabel;
    UIView *progressBackView, *progressView;
    UILabel *breathsRateDescLabel, *goalLabel;
}

@end
@implementation WBBreathRateCell

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
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_average_respiration_rate"]];
        [backView addSubview:imageView];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [imageView autoSetDimensionsToSize:CGSizeMake(37.0f, 37.0f)];
        
        breathsRateLabel = [[UILabel alloc] init];
        breathsRateLabel.backgroundColor = [UIColor clearColor];
        breathsRateLabel.font = [UIFont systemFontOfSize:15.0f];
        breathsRateLabel.textColor = RGB(87,104,106);
        [backView addSubview:breathsRateLabel];
        [breathsRateLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [breathsRateLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:7.0f];
        
        progressBackView = [[UIView alloc] init];
        progressBackView.backgroundColor = RGB(214,218,219);
        [backView addSubview:progressBackView];
        [progressBackView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imageView];
        [progressBackView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:7.0f];
        [progressBackView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [progressBackView autoSetDimension:ALDimensionHeight toSize:14.0f];
        
        progressView = [[UIView alloc] init];
        progressView.backgroundColor = RGB(126,78,174);
        [backView addSubview:progressView];
        
        breathsRateDescLabel = [[UILabel alloc] init];
        breathsRateDescLabel.backgroundColor = [UIColor clearColor];
        breathsRateDescLabel.font = [UIFont systemFontOfSize:12.0f];
        breathsRateDescLabel.textColor = [UIColor lightGrayColor];
        breathsRateDescLabel.text = NSLocalizedString(@"Respiration rate", nil);
        [backView addSubview:breathsRateDescLabel];
        [breathsRateDescLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:progressBackView withOffset:5.0f];
        [breathsRateDescLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:7.0f];
        
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
    breathsRateLabel.text = @"16.5 breaths per min";
    goalLabel.text = @"Usual level";
    
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
