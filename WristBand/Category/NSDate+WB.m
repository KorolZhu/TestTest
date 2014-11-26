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

@end
