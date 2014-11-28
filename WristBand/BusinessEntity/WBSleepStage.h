//
//  WBSleepStage.h
//  WristBand
//
//  Created by zhuzhi on 14/11/28.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSleepStage : NSObject

@property (nonatomic)WBSleepStageType type;
@property (nonatomic)double startTimeStamp;
@property (nonatomic)double endTimeStamp;
@property (nonatomic)double timeInterval;
@property (nonatomic)NSInteger startTag;
@property (nonatomic)NSInteger endTag;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
