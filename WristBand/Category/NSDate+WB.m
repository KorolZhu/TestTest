//
//  NSDate+WB.m
//  WristBand
//
//  Created by zhuzhi on 14/11/25.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "NSDate+WB.h"

@implementation NSDate (WB)

- (NSString *)stringWithFormat:(NSString *)format {
    static NSDateFormatter *formatter;
    GCDExecOnce(^{
        formatter = [[NSDateFormatter alloc] init];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [formatter setCalendar:calendar];
    });
    
    [formatter setDateFormat:format];
    NSString *formatString = [formatter stringFromDate:self];
    return formatString;
}

+ (NSInteger)currentHour {
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit| NSMinuteCalendarUnit;
    NSCalendar *calendar;
    calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger hour = [comps hour];
    return hour;
}

@end
