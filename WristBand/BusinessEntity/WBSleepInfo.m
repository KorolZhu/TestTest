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
    if (_toBedTime > 0) {
        NSDate *toBedDate = [NSDate dateWithTimeIntervalSince1970:self.toBedTime];
        _toBedTimeString = [NSString stringWithFormat:@"To bed %@", [NSDate detailDate:toBedDate]];
    }
    
    if (_toBedTime > 0 && _fallAsleepTime > 0) {
        NSTimeInterval interval = _fallAsleepTime - _toBedTime;
        _fallAsleepInTimeString = [NSString stringWithFormat:@"Fall asleep in %@", [NSDate formatSeconds:interval]];
    }
    
    if (_gotupTime > 0) {
        NSDate *gotupDate = [NSDate dateWithTimeIntervalSince1970:self.gotupTime];
        _gotupString = [NSString stringWithFormat:@"Got up %@", [NSDate detailDate:gotupDate]];
    }
    
    _goalPercent = _totalSleepTime / ([[NSUserDefaults standardUserDefaults] floatForKey:WBSleepTimeGoal] * 3 * 3600 + 6 * 3600);
    int hour = _totalSleepTime / 3600;
    int minute = (long)_totalSleepTime % 3600 / 60.0f;
    _totalSleepTimeString = [NSString stringWithFormat:@"%d h %d min", hour, minute];
    _goalPercentString = [NSString stringWithFormat:@"%.0f%% of goal", 100 * _goalPercent];
}

@end
