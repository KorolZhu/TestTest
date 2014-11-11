//
//  UINavigationBar+WB.m
//  WristBand
//
//  Created by zhuzhi on 14/11/11.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "UINavigationBar+WB.h"
#import <objc/runtime.h>

@implementation UINavigationBar (WB)

+ (void)load
{
	Method existing = class_getInstanceMethod(self, @selector(layoutSubviews));
	Method new = class_getInstanceMethod(self, @selector(_autolayout_replacementLayoutSubviews));
	
	method_exchangeImplementations(existing, new);
}

- (void)_autolayout_replacementLayoutSubviews
{
	[super layoutSubviews];
	[self _autolayout_replacementLayoutSubviews]; // not recursive due to method swizzling
	[super layoutSubviews];
}

@end
