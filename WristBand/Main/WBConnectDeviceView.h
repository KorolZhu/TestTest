//
//  WBConnectDeviceView.h
//  WristBand
//
//  Created by zhuzhi on 14/11/4.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBConnectDeviceView;
@class WBMeasuringView;

@protocol WBConnectDeviceViewDelegate <NSObject>

- (void)connectDeviceViewDidConnected:(WBConnectDeviceView *)view;

@end

@interface WBConnectDeviceView : UIView

@property (nonatomic,strong)WBMeasuringView *measuringView;
@property (nonatomic,strong)UIButton *startSleepingButton;
@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic)BOOL enabled;

@property (nonatomic,weak)id<WBConnectDeviceViewDelegate> delegate;

@end
