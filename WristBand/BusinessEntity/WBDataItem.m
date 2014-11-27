//
//  WBDataItem.m
//  WristBand
//
//  Created by zhuzhi on 14/11/27.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBDataItem.h"

@implementation WBDataItem

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        NSArray *temp = [string componentsSeparatedByString:@","];
        if (temp.count == 2) {
            self.value = [temp.firstObject integerValue];
            self.timeStamp = [temp.lastObject doubleValue];
        }
    }
    
    return self;
}

@end
