//
//  UIViewController+Container.h
//  WristBand
//
//  Created by zhuzhi on 14/11/9.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBContainViewController.h"

@interface UIViewController (Container)

@property(nonatomic,readonly,retain) WBContainViewController *containViewController;

@end
