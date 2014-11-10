//
//  WBSleepScore.m
//  WristBand
//
//  Created by zhuzhi on 14/11/9.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBSleepScore.h"

@implementation WBSleepScore

- (int)totalScore {
    return _amountOfSleep +
    _sleepVSAwake +
    _sleepLatency +
    _gotupFromBed +
    _wakingEvents +
    _snoring;
}

@end
