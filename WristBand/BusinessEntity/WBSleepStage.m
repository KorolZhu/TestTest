//
//  WBSleepStage.m
//  WristBand
//
//  Created by zhuzhi on 14/11/28.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBSleepStage.h"

@implementation WBSleepStage

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
		self.dateYMD = [dictionary integerForKey:@"DATEYMD"];
        self.startTimeStamp = [[dictionary objectForKey:@"STARTTIME"] doubleValue];
        self.endTimeStamp = [[dictionary objectForKey:@"ENDTIME"] doubleValue];
        self.type = [[dictionary objectForKey:@"STAGE"] intValue];
    }
    
    return self;
}

@end

