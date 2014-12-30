//
//  WBDataItem2.h
//  WristBand
//
//  Created by zhuzhi on 14/12/25.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	SleepStateNone,
	SleepStateStartSleep,
	SleepStateAwake,
	SleepStateLightSleep,
	SleepStateDeepSleep,
}SleepState;

@interface WBDataItem2 : NSObject

@property (nonatomic) SleepState sleepState;
@property (nonatomic) NSInteger snoring;
@property (nonatomic) NSInteger breathRate;
@property (nonatomic) NSInteger heartRate;
@property (nonatomic) NSInteger turnoverTimes;
@property (nonatomic) NSTimeInterval timeStamp;

- (instancetype)initWithString:(NSString *)string;

@end
