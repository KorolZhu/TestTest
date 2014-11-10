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
@property (nonatomic,readonly)NSString *timeString;
@property (nonatomic,strong)WBSleepScore *sleepScore;
@property (nonatomic,copy)NSString *improvementIdeas;
@property (nonatomic,copy)NSString *improvementIdeasDetail;
@property (nonatomic,assign)NSTimeInterval totalSleepTime;
@property (nonatomic,assign)float goalPercent;
@property (nonatomic,readonly)NSString *totalSleepTimeString;
@property (nonatomic,readonly)NSString *goalPercentString;
@property (nonatomic,strong)NSArray *sleepPoints;

- (void)setup;

@end
