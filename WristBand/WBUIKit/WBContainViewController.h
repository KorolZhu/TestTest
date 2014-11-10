//
//  WBContainViewController.h
//  WristBand
//
//  Created by zhuzhi on 14/11/8.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBContainViewController : UIViewController

@property (nonatomic,strong)NSArray *viewControllers;
@property (nonatomic,strong)UIViewController *currentViewController;
@property (nonatomic,strong)UIViewController *lastViewController;

@end
