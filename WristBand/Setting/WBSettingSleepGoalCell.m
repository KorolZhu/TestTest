//
//  WBSettingSleepGoalCell.m
//  WristBand
//
//  Created by zhuzhi on 14/11/3.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBSettingSleepGoalCell.h"

@interface WBSettingSleepGoalCell ()
{
    UIView *backView;
    UILabel *sleepTimeGoalLabel;
    UILabel *sleepTimeDescLabel;
}

@end

@implementation WBSettingSleepGoalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.text = NSLocalizedString(@"SLEEP TIME GOAL", nil);
        [self.contentView addSubview:label];
        [label autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor clearColor];
        backView.layer.borderColor = [[UIColor whiteColor] CGColor];
        backView.layer.borderWidth = 0.5f;
        backView.layer.cornerRadius = 6.0f;
        [self.contentView addSubview:backView];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:25.0f];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        
        sleepTimeGoalLabel = [[UILabel alloc] init];
        sleepTimeGoalLabel.backgroundColor = [UIColor clearColor];
        sleepTimeGoalLabel.textColor = [UIColor whiteColor];
        sleepTimeGoalLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        sleepTimeGoalLabel.text = NSLocalizedString(@"Sleep time goal", nil);
        [backView addSubview:sleepTimeGoalLabel];
        [sleepTimeGoalLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [sleepTimeGoalLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        
        UISlider *slider = [[UISlider alloc] init];
        slider.value = 0.5f;
        [backView addSubview:slider];
        [slider autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:sleepTimeGoalLabel withOffset:5.0f];
        [slider autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [slider autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        
        sleepTimeDescLabel = [[UILabel alloc] init];
        sleepTimeDescLabel.numberOfLines = 0;
        sleepTimeDescLabel.backgroundColor = [UIColor clearColor];
        sleepTimeDescLabel.textColor = [UIColor whiteColor];
        sleepTimeDescLabel.font = [UIFont boldSystemFontOfSize:11.0f];
        sleepTimeDescLabel.text = NSLocalizedString(@"Choose the amount of sleep you need daily. For most adults, 6-9 hours of sleep is enough. ", nil);
        [backView addSubview:sleepTimeDescLabel];
        [sleepTimeDescLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:slider withOffset:5.0f];
        [sleepTimeDescLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [sleepTimeDescLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        
        [backView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:sleepTimeDescLabel withOffset:12.0f];
    }
    
    return self;
    
}

- (void)configCell {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGFloat)cellHeight {
    return backView.bottom + 3.0f;
}

@end
