//
//  WBSleepScore.h
//  WristBand
//
//  Created by zhuzhi on 14/11/9.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSleepScore : NSObject

@property (nonatomic,assign)NSInteger amountOfSleep;
@property (nonatomic,assign)NSInteger sleepVSAwake;
@property (nonatomic,assign)NSInteger sleepLatency;
@property (nonatomic,assign)NSInteger gotupFromBed;
@property (nonatomic,assign)NSInteger wakingEvents;
@property (nonatomic,assign)NSInteger snoring;

@property (nonatomic,readonly)NSInteger totalScore;

@end
