//
//  WBSleepInfo.m
//  WristBand
//
//  Created by zhuzhi on 14/11/9.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBSleepInfo.h"

@implementation WBSleepInfo

- (void)setup {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    _timeString = [dateFormatter stringFromDate:date];
    
    _improvementIdeas = @"Exercise regularly";
    _improvementIdeasDetail = @"Aerobic exercise in the afternoon or at least 3 hours efore going to bed is good for sleep";
    
    _goalPercent = _totalSleepTime / (7.0f * 3600);
    int hour = _totalSleepTime / 3600;
    int minute = (long)_totalSleepTime % 3600 / 60.0f;
    _totalSleepTimeString = [NSString stringWithFormat:@"%d h %d min", hour, minute];
    _goalPercentString = [NSString stringWithFormat:@"%.0f%% of goal", 100 * _totalSleepTime / (7.0f * 3600)];
}

@end
