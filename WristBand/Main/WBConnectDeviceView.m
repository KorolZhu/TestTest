//
//  WBConnectDeviceView.m
//  WristBand
//
//  Created by zhuzhi on 14/11/4.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBConnectDeviceView.h"
#import <ExternalAccessory/ExternalAccessory.h>

@implementation WBConnectDeviceView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, IPHONE_HEIGHT + 43.0f)];
    if (self) {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        _startSleepingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startSleepingButton setTitleColor:RGB(149,164,165) forState:UIControlStateNormal];
        _startSleepingButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [_startSleepingButton setTitle:NSLocalizedString(@"Start sleeping", nil) forState:UIControlStateNormal];
        [_startSleepingButton setBackgroundImage:[UIImage imageNamed:@"button_background_image_day"] forState:UIControlStateNormal];
        [_startSleepingButton setBackgroundImage:[UIImage imageNamed:@"button_background_image_day_act"] forState:UIControlStateHighlighted];
        [self addSubview:_startSleepingButton];
        [_startSleepingButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_startSleepingButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_startSleepingButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_startSleepingButton autoSetDimension:ALDimensionHeight toSize:43.0f];
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = RGB(33,39,40);
        [self addSubview:backgroundView];
        [backgroundView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(43.0f, 0.0f, 0.0f, 0.0f)];
        
        UIView *barView = [[UIView alloc] init];
        barView.backgroundColor = [UIColor clearColor];
        [backgroundView addSubview:barView];
        [barView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [barView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [barView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [barView autoSetDimension:ALDimensionHeight toSize:64.0f];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"icon_x"] forState:UIControlStateNormal];
        [barView addSubview:_cancelButton];
        [_cancelButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:25.0f];
        [_cancelButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
        [_cancelButton autoSetDimensionsToSize:CGSizeMake(30.0f, 30.0f)];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        titleLabel.text = NSLocalizedString(@"Connect device", nil);
        [barView addSubview:titleLabel];
        [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_cancelButton];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        [barView addSubview:lineView];
        [lineView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(63.5f, 0.0f, 0.0f, 0.0f)];
        
        UIButton *connectDeviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [connectDeviceButton setBackgroundColor:[UIColor whiteColor]];
        [connectDeviceButton setTitleColor:RGB(33,39,40) forState:UIControlStateNormal];
        [connectDeviceButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [connectDeviceButton setTitle:NSLocalizedString(@"CONNECT DEVICE", nil) forState:UIControlStateNormal];
        [connectDeviceButton addTarget:self action:@selector(connectDeviceClick) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:connectDeviceButton];
        [connectDeviceButton autoSetDimensionsToSize:CGSizeMake(240.0f, 40.0f)];
        [connectDeviceButton autoCenterInSuperview];
        
        [self layoutIfNeeded];
    }
    
    return self;
}

- (void)connectDeviceClick {
    [[EAAccessoryManager sharedAccessoryManager] showBluetoothAccessoryPickerWithNameFilter:nil completion:^(NSError *error) {
        
    }];
}

@end
