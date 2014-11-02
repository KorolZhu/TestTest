//
//  WBSleepInfo.h
//  ChartViewController
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WBSleepInfoState) {
    WBSleepInfoStateNormal = 0,      // start sleep, but not in bed
    WBSleepInfoStateInbed,           // in bed , but not fall asleep
    WBSleepInfoStateFallAsleep,      // fall asleep
};

@interface WBSleepInfo : NSObject

@property (nonatomic)NSTimeInterval time;
@property (nonatomic)NSInteger hour;
@property (nonatomic)NSInteger minute;
@property (nonatomic)float sleepValue;
@property (nonatomic)WBSleepInfoState state;

@end
