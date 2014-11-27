//
//  WBDataOperation.m
//  WristBand
//
//  Created by zhuzhi on 14/11/27.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBDataOperation.h"
#import "WBDataItem.h"

@interface WBDataOperation ()
{
    NSMutableString *mutableString;
    
}

@end

@implementation WBDataOperation

WB_DEF_SINGLETON(WBDataOperation, shareInstance);

- (instancetype)init {
    self = [super init];
    if (self) {
        mutableString = [[NSMutableString alloc] init];
    }
    
    return self;
}

- (void)bleDidReceiveData:(UInt16)value {
    NSString *string = [NSString stringWithFormat:@"%4d,%.3f;", value, [[NSDate date] timeIntervalSince1970]];
    [mutableString appendString:string];
}

- (void)analysing {
    NSString *string = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test2" ofType:@"rtf"] encoding:NSUTF8StringEncoding error:NULL];
//    NSArray *dataArray = [mutableString componentsSeparatedByString:@";"];
    NSArray *dataArray = [string componentsSeparatedByString:@";"];
    
    NSMutableArray *intervalArray = [NSMutableArray array];
    
    // 算出每两个值之间的差值
    for (int i = 0; i < dataArray.count; i++) {
        NSString *string = [dataArray objectAtIndex:i];
        WBDataItem *item = [[WBDataItem alloc] initWithString:string];
        
        if (i + 1 < dataArray.count) {
            NSString *string1 = [dataArray objectAtIndex:i + 1];
            WBDataItem *item1 = [[WBDataItem alloc] initWithString:string1];
            
            [intervalArray addObject:@(ABS(item1.value - item.value))];
        }
    }
    
    NSMutableArray *tempDataArray = [NSMutableArray arrayWithArray:dataArray];
    NSMutableArray *tempIntervalArray = [NSMutableArray arrayWithArray:intervalArray];
    
    // 找出空载的时间: 平均值少于18,时间大于15秒
    for (int i = 0; i < intervalArray.count; ) {
        long long total = 0;
        
        int j = i;
        do {
            UInt16 interval = [[intervalArray objectAtIndex:j] integerValue];
            total += interval;
            j++;
        } while (total / (float)(j - i) < 18 && j < intervalArray.count);
        
        NSLog(@"j - i = %d , j = %d, intervale = %d", j - i, j, [[intervalArray objectAtIndex:j] integerValue]);

        if (j - i >= 15 * 5) {
            [tempDataArray removeObjectsInRange:NSMakeRange(i, j - i)];
            [tempIntervalArray removeObjectsInRange:NSMakeRange(i, j - i)];
        }
        
        if (j >= intervalArray.count - 10) {
            break;
        }
        
        i = j;
        
    }
    
    dataArray = [NSArray arrayWithArray:tempDataArray];
    intervalArray = [NSMutableArray arrayWithArray:tempIntervalArray];
    
    // 找出醒着的时间: 平均值大于350,时间大于5秒
    for (int i = 0; i < intervalArray.count; ) {
        long long total = 0;
        
        int j = i;
        UInt16 interval = 0;

        do {
            interval = [[intervalArray objectAtIndex:j] integerValue];
            total += interval;
            j++;
        } while ((total / (float)(j - i) > 350 || (interval < 500 || interval > 1500)) && j < intervalArray.count);
        
        NSLog(@"j - i = %d , j = %d, intervale = %d", j - i, j, [[intervalArray objectAtIndex:j] integerValue]);
        
        if (j - i >= 5 * 5) {
            [tempDataArray removeObjectsInRange:NSMakeRange(i, j - i)];
            [tempIntervalArray removeObjectsInRange:NSMakeRange(i, j - i)];
        }
        
        if (j >= intervalArray.count - 10) {
            break;
        }
        
        i = j;
        
    }
    
}

@end
