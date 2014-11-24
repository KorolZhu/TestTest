//
//  NSString+WB.m
//  WristBand
//
//  Created by zhuzhi on 14/11/24.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "NSString+WB.h"

@implementation NSString (WB)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)containString:(NSString *)string {
    if (!string || string.length <= 0) {
        return NO;
    }
    return ([self rangeOfString:string].location != NSNotFound);
}

@end
