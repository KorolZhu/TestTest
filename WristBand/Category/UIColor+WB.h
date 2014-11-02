//
//  UIColor+WB.h
//  WristBand
//
//  Created by zhuzhi on 14/11/2.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r,g,b) [UIColor rgbColorWithRed:r green:g blue:b]
#define RGBA(r,g,b,a) [UIColor rgbColorWithRed:r green:g blue:b alpha:a]

@interface UIColor (WB)

+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue;
+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

@end
