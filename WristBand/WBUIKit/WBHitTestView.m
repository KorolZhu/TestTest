//
//  WBHitTestView.m
//  WristBand
//
//  Created by zhuzhi on 14/11/9.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBHitTestView.h"

@implementation WBHitTestView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 扩大view的点击区域
    if (CGRectContainsPoint(self.bounds, point)) {
        return [super hitTest:point withEvent:event];
    }
    
    for (UIView *subview in self.subviews) {
        if (CGRectContainsPoint(subview.frame, point)) {
            CGPoint pointInSubview = [self convertPoint:point toView:subview];
            return [subview hitTest:pointInSubview withEvent:event];
        }
    }
    
    return nil;
}

@end
