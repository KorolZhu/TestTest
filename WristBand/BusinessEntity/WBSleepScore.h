//
//  WBSleepScore.h
//  WristBand
//
//  Created by zhuzhi on 14/11/9.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSleepScore : NSObject

@property (nonatomic,assign)int amountOfSleep;
@property (nonatomic,assign)int sleepVSAwake;
@property (nonatomic,assign)int sleepLatency;
@property (nonatomic,assign)int gotupFromBed;
@property (nonatomic,assign)int wakingEvents;
@property (nonatomic,assign)int snoring;

@property (nonatomic,readonly)int totalScore;

@end
