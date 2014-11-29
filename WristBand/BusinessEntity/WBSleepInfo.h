//
//  WBSleepInfo.h
//  WristBand
//
//  Created by zhuzhi on 14/11/9.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBSleepScore.h"

@interface WBSleepInfo : NSObject

@property (nonatomic,assign)NSTimeInterval time;
@property (nonatomic,assign)NSTimeInterval toBedTime;
@property (nonatomic,strong)NSString *toBedTimeString;
@property (nonatomic,assign)NSTimeInterval fallAsleepTime;
@property (nonatomic,strong)NSString* fallAsleepInTimeString;
@property (nonatomic,readonly)NSString *timeString;
@property (nonatomic,strong)WBSleepScore *sleepScore;
@property (nonatomic,copy)NSString *improvementIdeas;
@property (nonatomic,copy)NSString *improvementIdeasDetail;
@property (nonatomic,assign)NSTimeInterval totalSleepTime;
@property (nonatomic,readonly)NSString *totalSleepTimeString;
@property (nonatomic,assign)float goalPercent;
@property (nonatomic,readonly)NSString *goalPercentString;

@property (nonatomic)NSInteger bpm;
@property (nonatomic)NSInteger breathspm;
@property (nonatomic,strong)NSArray *sleepPoints;

- (void)setup;

@end
