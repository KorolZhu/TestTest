//
//  WBSleepStage.m
//  WristBand
//
//  Created by zhuzhi on 14/11/28.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBSleepStage.h"

@implementation WBSleepStage

- (double)timeInterval {
	return _endTimeStamp - _startTimeStamp;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
	}
	
	return self;
}

@end
