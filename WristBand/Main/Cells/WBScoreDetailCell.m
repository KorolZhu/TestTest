//
//  WBScoreDetailCell.m
//  WristBand
//
//  Created by zhuzhi on 14/11/2.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBScoreDetailCell.h"

@interface WBScoreDetailCell ()
{
    UIImageView *topBackView;
    UIView *backView;

    UILabel *titleLabel;
    UIButton *deleteButton;

    UILabel *amoutOfSleepLabel, *amoutOfSleepValueLabel;
    UILabel *sleepVSAwakeLabel, *sleepVSAwakeValueLabel;
    UILabel *sleepLatencyLabel, *sleepLatencyValueLabel;
    UILabel *gotupLabel, *gotupValueLabel;
    UILabel *wakingEventsLabel, *wakingEventsValueLabel;
    UILabel *snoringLabel, *snoringValueLabel;
    UIImageView *sepearateView;
    UILabel *totalLabel, *totalValueLabel;
}

@end

@implementation WBScoreDetailCell

- (instancetype)init {
    self = [super init];
    if (self) {        
        UIImage *image = [[UIImage imageNamed:@"score_breakdown"] resizableImageWithCapInsets:UIEdgeInsetsMake(50.0f, 13.0f, 30.0f, 33.0f)];
        topBackView = [[UIImageView alloc] initWithImage:image];
        [self.contentView addSubview:topBackView];
        [topBackView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0f];
        [topBackView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10.0f];
        [topBackView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10.0f];
        [topBackView autoSetDimension:ALDimensionHeight toSize:44.0f];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        [titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:topBackView withOffset:15.0f];
        [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:topBackView withOffset:10.0f];
        [titleLabel autoSetDimension:ALDimensionWidth toSize:200.0f];
        
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"icon_x"] forState:UIControlStateNormal];
        [self addSubview:deleteButton];
        [deleteButton autoSetDimensionsToSize:CGSizeMake(30.0f, 30.0f)];
        [deleteButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleLabel];
        [deleteButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:topBackView withOffset:-5.0f];
        
        amoutOfSleepLabel = [[UILabel alloc] init];
        amoutOfSleepLabel.backgroundColor = [UIColor clearColor];
        amoutOfSleepLabel.font = [UIFont systemFontOfSize:16.0f];
        amoutOfSleepLabel.textColor = [UIColor blackColor];
        [self addSubview:amoutOfSleepLabel];
        [amoutOfSleepLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:15.0f];
        [amoutOfSleepLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleLabel];
        [amoutOfSleepLabel autoSetDimension:ALDimensionWidth toSize:200.0f];
        
        amoutOfSleepValueLabel = [[UILabel alloc] init];
        amoutOfSleepValueLabel.textAlignment = NSTextAlignmentCenter;
        amoutOfSleepValueLabel.backgroundColor = RGB(132, 132, 132);
        amoutOfSleepValueLabel.font = [UIFont systemFontOfSize:15.0f];
        amoutOfSleepValueLabel.textColor = [UIColor whiteColor];
        amoutOfSleepValueLabel.layer.cornerRadius = 9.0f;
        amoutOfSleepValueLabel.clipsToBounds = YES;
        [self addSubview:amoutOfSleepValueLabel];
        [amoutOfSleepValueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:amoutOfSleepLabel];
        [amoutOfSleepValueLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:deleteButton withOffset:-3.0f];
        [amoutOfSleepValueLabel autoSetDimension:ALDimensionWidth toSize:40.0f];
        
        sleepVSAwakeLabel = [[UILabel alloc] init];
        sleepVSAwakeLabel.backgroundColor = [UIColor clearColor];
        sleepVSAwakeLabel.font = [UIFont systemFontOfSize:16.0f];
        sleepVSAwakeLabel.textColor = [UIColor blackColor];
        [self addSubview:sleepVSAwakeLabel];
        [sleepVSAwakeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:amoutOfSleepLabel withOffset:12.0f];
        [sleepVSAwakeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleLabel];
        [sleepVSAwakeLabel autoSetDimension:ALDimensionWidth toSize:200.0f];
        
        sleepVSAwakeValueLabel = [[UILabel alloc] init];
        sleepVSAwakeValueLabel.textAlignment = NSTextAlignmentCenter;
        sleepVSAwakeValueLabel.backgroundColor = RGB(132, 132, 132);
        sleepVSAwakeValueLabel.font = [UIFont systemFontOfSize:15.0f];
        sleepVSAwakeValueLabel.textColor = [UIColor whiteColor];
        sleepVSAwakeValueLabel.layer.cornerRadius = 9.0f;
        sleepVSAwakeValueLabel.clipsToBounds = YES;
        [self addSubview:sleepVSAwakeValueLabel];
        [sleepVSAwakeValueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:sleepVSAwakeLabel];
        [sleepVSAwakeValueLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:deleteButton withOffset:-3.0f];
        [sleepVSAwakeValueLabel autoSetDimension:ALDimensionWidth toSize:40.0f];
        
        sleepLatencyLabel = [[UILabel alloc] init];
        sleepLatencyLabel.backgroundColor = [UIColor clearColor];
        sleepLatencyLabel.font = [UIFont systemFontOfSize:16.0f];
        sleepLatencyLabel.textColor = [UIColor blackColor];
        [self addSubview:sleepLatencyLabel];
        [sleepLatencyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:sleepVSAwakeLabel withOffset:12.0f];
        [sleepLatencyLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleLabel];
        [sleepLatencyLabel autoSetDimension:ALDimensionWidth toSize:200.0f];
        
        sleepLatencyValueLabel = [[UILabel alloc] init];
        sleepLatencyValueLabel.textAlignment = NSTextAlignmentCenter;
        sleepLatencyValueLabel.backgroundColor = RGB(132, 132, 132);
        sleepLatencyValueLabel.font = [UIFont systemFontOfSize:15.0f];
        sleepLatencyValueLabel.textColor = [UIColor whiteColor];
        sleepLatencyValueLabel.layer.cornerRadius = 9.0f;
        sleepLatencyValueLabel.clipsToBounds = YES;
        [self addSubview:sleepLatencyValueLabel];
        [sleepLatencyValueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:sleepLatencyLabel];
        [sleepLatencyValueLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:deleteButton withOffset:-3.0f];
        [sleepLatencyValueLabel autoSetDimension:ALDimensionWidth toSize:40.0f];
        
        gotupLabel = [[UILabel alloc] init];
        gotupLabel.backgroundColor = [UIColor clearColor];
        gotupLabel.font = [UIFont systemFontOfSize:16.0f];
        gotupLabel.textColor = [UIColor blackColor];
        [self addSubview:gotupLabel];
        [gotupLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:sleepLatencyLabel withOffset:12.0f];
        [gotupLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleLabel];
        [gotupLabel autoSetDimension:ALDimensionWidth toSize:200.0f];
        
        gotupValueLabel = [[UILabel alloc] init];
        gotupValueLabel.textAlignment = NSTextAlignmentCenter;
        gotupValueLabel.backgroundColor = RGB(132, 132, 132);
        gotupValueLabel.font = [UIFont systemFontOfSize:15.0f];
        gotupValueLabel.textColor = [UIColor whiteColor];
        gotupValueLabel.layer.cornerRadius = 9.0f;
        gotupValueLabel.clipsToBounds = YES;
        [self addSubview:gotupValueLabel];
        [gotupValueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:gotupLabel];
        [gotupValueLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:deleteButton withOffset:-3.0f];
        [gotupValueLabel autoSetDimension:ALDimensionWidth toSize:40.0f];
        
        wakingEventsLabel = [[UILabel alloc] init];
        wakingEventsLabel.backgroundColor = [UIColor clearColor];
        wakingEventsLabel.font = [UIFont systemFontOfSize:16.0f];
        wakingEventsLabel.textColor = [UIColor blackColor];
        [self addSubview:wakingEventsLabel];
        [wakingEventsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:gotupLabel withOffset:12.0f];
        [wakingEventsLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleLabel];
        [wakingEventsLabel autoSetDimension:ALDimensionWidth toSize:200.0f];
        
        wakingEventsValueLabel = [[UILabel alloc] init];
        wakingEventsValueLabel.textAlignment = NSTextAlignmentCenter;
        wakingEventsValueLabel.backgroundColor = RGB(132, 132, 132);
        wakingEventsValueLabel.font = [UIFont systemFontOfSize:15.0f];
        wakingEventsValueLabel.textColor = [UIColor whiteColor];
        wakingEventsValueLabel.layer.cornerRadius = 9.0f;
        wakingEventsValueLabel.clipsToBounds = YES;
        [self addSubview:wakingEventsValueLabel];
        [wakingEventsValueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:wakingEventsLabel];
        [wakingEventsValueLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:deleteButton withOffset:-3.0f];
        [wakingEventsValueLabel autoSetDimension:ALDimensionWidth toSize:40.0f];
        
        snoringLabel = [[UILabel alloc] init];
        snoringLabel.backgroundColor = [UIColor clearColor];
        snoringLabel.font = [UIFont systemFontOfSize:16.0f];
        snoringLabel.textColor = [UIColor blackColor];
        [self addSubview:snoringLabel];
        [snoringLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:wakingEventsLabel withOffset:12.0f];
        [snoringLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleLabel];
        [snoringLabel autoSetDimension:ALDimensionWidth toSize:200.0f];
        
        snoringValueLabel = [[UILabel alloc] init];
        snoringValueLabel.textAlignment = NSTextAlignmentCenter;
        snoringValueLabel.backgroundColor = RGB(132, 132, 132);
        snoringValueLabel.font = [UIFont systemFontOfSize:15.0f];
        snoringValueLabel.textColor = [UIColor whiteColor];
        snoringValueLabel.layer.cornerRadius = 9.0f;
        snoringValueLabel.clipsToBounds = YES;
        [self addSubview:snoringValueLabel];
        [snoringValueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:snoringLabel];
        [snoringValueLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:deleteButton withOffset:-3.0f];
        [snoringValueLabel autoSetDimension:ALDimensionWidth toSize:40.0f];
        
        sepearateView = [[UIImageView alloc] init];
        sepearateView.backgroundColor = [UIColor blackColor];
        [self addSubview:sepearateView];
        [sepearateView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:snoringLabel withOffset:8.0];
        [sepearateView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:topBackView];
        [sepearateView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:topBackView];
        [sepearateView autoSetDimension:ALDimensionHeight toSize:1.0f];
        
        totalLabel = [[UILabel alloc] init];
        totalLabel.backgroundColor = [UIColor clearColor];
        totalLabel.font = [UIFont systemFontOfSize:16.0f];
        totalLabel.textColor = RGB(63,164,193);
        [self addSubview:totalLabel];
        [totalLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:sepearateView withOffset:8.0f];
        [totalLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleLabel];
        [totalLabel autoSetDimension:ALDimensionWidth toSize:200.0f];
        
        totalValueLabel = [[UILabel alloc] init];
        totalValueLabel.textAlignment = NSTextAlignmentCenter;
        totalValueLabel.backgroundColor = RGB(63,164,193);
        totalValueLabel.font = [UIFont systemFontOfSize:15.0f];
        totalValueLabel.textColor = [UIColor whiteColor];
        totalValueLabel.layer.cornerRadius = 9.0f;
        totalValueLabel.clipsToBounds = YES;
        [self addSubview:totalValueLabel];
        [totalValueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:totalLabel];
        [totalValueLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:deleteButton withOffset:-3.0f];
        [totalValueLabel autoSetDimension:ALDimensionWidth toSize:40.0f];
        
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 2.0f;
        [self insertSubview:backView atIndex:0];
        [backView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topBackView withOffset:-2.0f];
        [backView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:topBackView];
        [backView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:topBackView];
        [backView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:totalLabel withOffset:10.0f];
        
    }
    return self;
}

- (CGFloat)cellHeight {
    return backView.bottom + 15.0f;
}

- (void)configCell {
    titleLabel.text = NSLocalizedString(@"Sleep score breakdown", nil);
    amoutOfSleepLabel.text = NSLocalizedString(@"Amout of sleep", nil);
    amoutOfSleepValueLabel.text = @(self.sleepInfo.sleepScore.amountOfSleep).stringValue;
    
    sleepVSAwakeLabel.text = NSLocalizedString(@"Sleep vs. awake time", nil);
    int sleepVSAwake = self.sleepInfo.sleepScore.sleepVSAwake;
    NSString *sleepVSAwakeString = @"";
    if (sleepVSAwake > 0) {
        sleepVSAwakeString = [NSString stringWithFormat:@"+%d", sleepVSAwake];
    } else if (sleepVSAwake < 0){
        sleepVSAwakeString = [NSString stringWithFormat:@"%d", sleepVSAwake];
    } else {
        sleepVSAwakeString = @"0";
    }
    sleepVSAwakeValueLabel.text = sleepVSAwakeString;
    
    sleepLatencyLabel.text = NSLocalizedString(@"Sleep latency", nil);
    int sleepLatency = self.sleepInfo.sleepScore.sleepLatency;
    NSString *sleepLatencyString = @"";
    if (sleepLatency > 0) {
        sleepLatencyString = [NSString stringWithFormat:@"+%d", sleepLatency];
    } else if (sleepVSAwake < 0){
        sleepLatencyString = [NSString stringWithFormat:@"%d", sleepLatency];
    } else {
        sleepLatencyString = @"0";
    }
    sleepLatencyValueLabel.text = sleepLatencyString;
    
    gotupLabel.text = NSLocalizedString(@"Got up from bed", nil);
    int gotup = self.sleepInfo.sleepScore.gotupFromBed;
    NSString *gotupString = @"";
    if (gotup > 0) {
        gotupString = [NSString stringWithFormat:@"+%d", gotup];
    } else if (gotup < 0){
        gotupString = [NSString stringWithFormat:@"%d", gotup];
    } else {
        gotupString = @"0";
    }
    gotupValueLabel.text = gotupString;
    
    wakingEventsLabel.text = NSLocalizedString(@"Waking events", nil);
    int wakingEvents = self.sleepInfo.sleepScore.wakingEvents;
    NSString *wakingEventsString = @"";
    if (wakingEvents > 0) {
        wakingEventsString = [NSString stringWithFormat:@"+%d", wakingEvents];
    } else if (wakingEvents < 0){
        wakingEventsString = [NSString stringWithFormat:@"%d", wakingEvents];
    } else {
        wakingEventsString = @"0";
    }
    wakingEventsValueLabel.text = wakingEventsString;
    
    
    snoringLabel.text = NSLocalizedString(@"Snoring", nil);
    int snoring = self.sleepInfo.sleepScore.snoring;
    NSString *snoringString = @"";
    if (snoring > 0) {
        snoringString = [NSString stringWithFormat:@"+%d", snoring];
    } else if (snoring < 0){
        snoringString = [NSString stringWithFormat:@"%d", snoring];
    } else {
        snoringString = @"0";
    }
    snoringValueLabel.text = snoringString;
    
    totalLabel.text = NSLocalizedString(@"Total", nil);
    totalValueLabel.text = @(self.sleepInfo.sleepScore.totalScore).stringValue;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
