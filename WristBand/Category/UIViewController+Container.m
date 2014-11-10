//
//  UIViewController+Container.m
//  WristBand
//
//  Created by zhuzhi on 14/11/9.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "UIViewController+Container.h"

@implementation UIViewController (Container)

- (WBContainViewController *)containViewController {
    if ([self.parentViewController isKindOfClass:[WBContainViewController class]]) {
        return (WBContainViewController *)self.parentViewController;
    }
    return nil;
}

@end
