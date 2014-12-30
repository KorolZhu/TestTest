//
//  WBDataItem2.m
//  WristBand
//
//  Created by zhuzhi on 14/12/25.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBDataItem2.h"

@implementation WBDataItem2

- (instancetype)initWithString:(NSString *)string {
	self = [super init];
	if (self) {
		NSArray *temp = [string componentsSeparatedByString:@","];
		if (temp.count == 6) {
			self.sleepState = [temp.firstObject integerValue];
			self.snoring = [[temp objectAtIndex:1] integerValue];
			self.breathRate = [[temp objectAtIndex:2] integerValue];
			self.heartRate = [[temp objectAtIndex:3] integerValue];
			self.turnoverTimes = [[temp objectAtIndex:4] integerValue];
			self.timeStamp = [temp.lastObject doubleValue];
		}
	}
	
	return self;
}

@end
