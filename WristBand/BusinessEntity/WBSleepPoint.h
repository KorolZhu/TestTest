//
//  WBSleepInfo.h
//  ChartViewController
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSleepPoint : NSObject

@property (nonatomic)NSTimeInterval time;
@property (nonatomic)NSInteger hour;
@property (nonatomic)NSInteger minute;
@property (nonatomic)float sleepValue;
@property (nonatomic)WBSleepStageType state;

@end
