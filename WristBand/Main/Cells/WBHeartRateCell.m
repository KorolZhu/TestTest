//
//  WBHeartRateCell.m
//  WristBand
//
//  Created by zhuzhi on 14/11/21.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBHeartRateCell.h"

@interface WBHeartRateCell ()
{
    UIView *backView;
    UIImageView *imageView;
    UILabel *heartRateLabel;
    UIView *progressBackView, *progressView;
    UILabel *heartRateDescLabel, *goalLabel;
}

@end

@implementation WBHeartRateCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_heart_wide"]];
        [backView addSubview:imageView];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [imageView autoSetDimensionsToSize:CGSizeMake(44.0f, 36.0f)];
        
        heartRateLabel = [[UILabel alloc] init];
        heartRateLabel.backgroundColor = [UIColor clearColor];
        heartRateLabel.font = [UIFont systemFontOfSize:15.0f];
        heartRateLabel.textColor = RGB(87,104,106);
        [backView addSubview:heartRateLabel];
        [heartRateLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [heartRateLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:7.0f];
        
        progressBackView = [[UIView alloc] init];
        progressBackView.backgroundColor = RGB(214,218,219);
        [backView addSubview:progressBackView];
        [progressBackView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imageView];
        [progressBackView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:7.0f];
        [progressBackView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [progressBackView autoSetDimension:ALDimensionHeight toSize:14.0f];
        
        progressView = [[UIView alloc] init];
        progressView.backgroundColor = RGB(248,30,44);
        [backView addSubview:progressView];
        
        heartRateDescLabel = [[UILabel alloc] init];
        heartRateDescLabel.backgroundColor = [UIColor clearColor];
        heartRateDescLabel.font = [UIFont systemFontOfSize:12.0f];
        heartRateDescLabel.textColor = [UIColor lightGrayColor];
        heartRateDescLabel.text = NSLocalizedString(@"Resting heart rate", nil);
        [backView addSubview:heartRateDescLabel];
        [heartRateDescLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:progressBackView withOffset:5.0f];
        [heartRateDescLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:7.0f];
        
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
    heartRateLabel.text = [NSString stringWithFormat:@"%ldbpm", (long)self.sleepInfo.bpm];
    goalLabel.text = @"Usual level";
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    float percent = self.sleepInfo.bpm / 65.0f;
    CGRect frame = progressBackView.frame;
    frame.size.width = progressBackView.width * (percent > 1.0f ? 1.0f : percent);
    progressView.frame = frame;
}

- (CGFloat)cellHeight {
    return backView.bottom + 8.0f;
}

@end
