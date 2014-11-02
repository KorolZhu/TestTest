//
//  UIView+WB.h
//  WristBand
//
//  Created by zhuzhi on 14/11/2.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WB)

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)top;
- (CGFloat)left;
- (CGFloat)bottom;
- (CGFloat)right;
- (CGFloat)centerX;
- (CGFloat)centerY;

- (void)setTop:(CGFloat)top;
- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;

@end

@interface UIView (Private)

- (NSString *)recursiveDescription;

@end
