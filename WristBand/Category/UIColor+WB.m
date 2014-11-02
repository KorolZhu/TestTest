//
//  UIColor+WB.m
//  WristBand
//
//  Created by zhuzhi on 14/11/2.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "UIColor+WB.h"

@implementation UIColor (WB)

+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue {
    return [UIColor rgbColorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

@end
