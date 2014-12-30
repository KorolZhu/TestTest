//
//  WBConnectDeviceView.m
//  WristBand
//
//  Created by zhuzhi on 14/11/4.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBConnectDeviceView.h"
#import "WBMeasuringView.h"
#import "WBDataOperation.h"
#import "SWAccessoryPickerView.h"

typedef NS_ENUM(NSUInteger, WBConnectDeviceState) {
    WBConnectDeviceStateNormal,
    WBConnectDeviceStateConnecting,
    WBConnectDeviceStateConnected,
};

@interface WBConnectDeviceView ()<BLEDelegate,SWAccessoryPickerViewDelegate>
{
    UIView *barView;
    UIButton *connectDeviceButton;
    UIActivityIndicatorView *activityIndicatorView;
        
    NSTimer *writeTimer;
    
    SWAccessoryPickerView *accessoryPickerView;
}

@property (nonatomic)WBConnectDeviceState state;

@end

@implementation WBConnectDeviceView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, IPHONE_HEIGHT + 43.0f)];
    if (self) {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        _enabled = YES;
        
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
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        [_startSleepingButton addGestureRecognizer:_panGestureRecognizer];
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = RGB(33,39,40);
        [self addSubview:backgroundView];
        [backgroundView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(43.0f, 0.0f, 0.0f, 0.0f)];
        
        barView = [[UIView alloc] init];
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
        
        connectDeviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [connectDeviceButton setBackgroundColor:[UIColor whiteColor]];
        [connectDeviceButton setTitleColor:RGB(33,39,40) forState:UIControlStateNormal];
        [connectDeviceButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [connectDeviceButton setTitle:NSLocalizedString(@"CONNECT DEVICE", nil) forState:UIControlStateNormal];
        [connectDeviceButton addTarget:self action:@selector(connectDeviceClick) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:connectDeviceButton];
        [connectDeviceButton autoSetDimensionsToSize:CGSizeMake(240.0f, 40.0f)];
        [connectDeviceButton autoCenterInSuperview];
        
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.hidesWhenStopped = YES;
        [connectDeviceButton addSubview:activityIndicatorView];
        [activityIndicatorView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
        [activityIndicatorView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self layoutIfNeeded];
        
        [BLEShareInstance controlSetup];
        BLEShareInstance.delegate = self;
    }
    
    return self;
}

- (void)setState:(WBConnectDeviceState)state {
    _state = state;
    
    switch (state) {
        case WBConnectDeviceStateNormal: {
            [UIView animateWithDuration:0.2f animations:^{
                connectDeviceButton.backgroundColor = [UIColor whiteColor];
                [activityIndicatorView stopAnimating];
                self.top += barView.height;
            } completion:^(BOOL finished) {
                barView.hidden = NO;
                connectDeviceButton.enabled = YES;
            }];
        }
            break;
        case WBConnectDeviceStateConnecting: {
            [UIView animateWithDuration:0.2f animations:^{
                barView.hidden = YES;
                connectDeviceButton.enabled = NO;
                connectDeviceButton.backgroundColor = RGB(131,135,136);
                [activityIndicatorView startAnimating];
                self.top -= barView.height;
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case WBConnectDeviceStateConnected:
            
            break;
        default:
            break;
    }
}

- (void)connectDeviceClick {
    if (!accessoryPickerView) {
        accessoryPickerView = [[SWAccessoryPickerView alloc] initWithFrame:CGRectMake(22.0f, 100.0f, IPHONE_WIDTH - 44.0f, IPHONE_HEIGHT - 200.0f)];
        accessoryPickerView.title = NSLocalizedString(@"请选择蓝牙设备", nil);
        accessoryPickerView.delegate = self;
    }
    
    [accessoryPickerView show];
    [accessoryPickerView setDataSource:nil];
    
//    self.state = WBConnectDeviceStateConnecting;
    
    if (BLEShareInstance.activePeripheral)
        if([BLE shareInstance].activePeripheral.state == CBPeripheralStateConnected)
        {
            [[BLEShareInstance CM] cancelPeripheralConnection:BLEShareInstance.activePeripheral];
            return;
        }
    
    if (BLEShareInstance.peripherals)
        BLEShareInstance.peripherals = nil;
    
//    [BLEShareInstance findBLEPeripherals:3];
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanPeripheraTimer) userInfo:nil repeats:NO];
    
    [BLEShareInstance findBLEPeripherals];
    [BLEShareInstance addObserver:self forKeyPath:@"peripherals" options: NSKeyValueObservingOptionNew context:NULL];
}

- (void)accessoryPickerView:(SWAccessoryPickerView *)pickerView didSelectPeripheral:(CBPeripheral *)peripheral {
    [BLEShareInstance removeObserver:self forKeyPath:@"peripherals"];
    [BLEShareInstance.CM stopScan];
    [accessoryPickerView hide];
    [BLEShareInstance connectPeripheral:[BLEShareInstance.peripherals objectAtIndex:0]];
    self.state = WBConnectDeviceStateConnecting;
}

- (void)accessoryPickerViewDidCancel:(SWAccessoryPickerView *)pickerView {
    [BLEShareInstance removeObserver:self forKeyPath:@"peripherals"];
    [BLEShareInstance.CM stopScan];
    [accessoryPickerView hide];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"peripherals"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (accessoryPickerView.isVisible) {
                accessoryPickerView.dataSource = [NSArray arrayWithArray:BLEShareInstance.peripherals];
            }
        });
    }
}

- (void)scanPeripheraTimer {
    if (BLEShareInstance.peripherals.count > 0) {
        [BLEShareInstance connectPeripheral:[BLEShareInstance.peripherals objectAtIndex:0]];
    } else {
        self.state = WBConnectDeviceStateNormal;
    }
}

#pragma mark - BLEDelegate

- (void)bleDidConnect {
    if (!_measuringView) {
        _measuringView = [[WBMeasuringView alloc] init];
    }
    
    if (!_measuringView.superview) {
        self.superview.top = IPHONE_HEIGHT;
        _measuringView.top = -IPHONE_HEIGHT;
        [self.superview addSubview:_measuringView];
        [_measuringView startAnimation];
    }

	[[WBDataOperation shareInstance] startSleep];
	
    self.state = WBConnectDeviceStateNormal;
    
    writeTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(writeTimer:) userInfo:nil repeats:YES];
}

-(void)writeTimer:(NSTimer *)timer {
    UInt8 buf[] = {0x07};
    NSData *data = [[NSData alloc] initWithBytes:buf length:1];
    [BLEShareInstance write:data];
}

- (void)bleDidWriteValue {
    
}

- (void)bleDidDisconnect {
    [writeTimer invalidate];
    [_measuringView bleDidDisconnect];
    self.state = WBConnectDeviceStateNormal;
}

- (void)bleDidReceiveData:(unsigned char *)data length:(int)length {
    [[WBDataOperation shareInstance] bleDidReceiveData:data length:length];
}

@end
