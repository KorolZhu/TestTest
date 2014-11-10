//
//  WBSleepInfo.m
//  ChartViewController
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "WBSleepPoint.h"

@implementation WBSleepPoint

- (void)setTime:(NSTimeInterval)time {
    if (time != _time) {
        _time = time;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour| NSCalendarUnitMinute;
        static NSCalendar *calendar;
        if (!calendar) {
            calendar = [NSCalendar currentCalendar];
        }
        
        // Create reference date for supplied date.
        NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
        NSInteger hour = [comps hour];
        NSInteger minute = [comps minute];
        self.hour = hour;
        self.minute = minute;
        
//        NSLog(@"hour = %ld", hour);
    }
}
@end
