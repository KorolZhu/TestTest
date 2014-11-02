//
//  UIDevice+WB.h
//  WristBand
//
//  Created by zhuzhi on 14/11/2.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (WB)

- (BOOL)isIOS7;
- (BOOL)isIOS8;

- (float)screenWidth;
- (float)screenHeight;
- (float)statusbarWidth;
- (float)statusbarHeight;

@end
