//
//  WBMeasuringView.m
//  WristBand
//
//  Created by zhuzhi on 14/11/4.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBMeasuringView.h"
#import "WBDataOperation.h"
#import "HTDatePicker.h"

@interface WBMeasuringView ()<HTDatePickerDelegate>
{
    UIView *alarmView;
    UILabel *alarmoffLabel;
    UILabel *alarmTimeLabel;
    UISwitch *alarmSwitch;
    UILabel *alarmDescLabel;
    UIView *lineView;
    UIView *backView;
    UILabel *measuringLabel;
    UIImageView *animationView;
    UIButton *stopMeasuringButton;
    CABasicAnimation *rotationAnimation;
    
    NSLayoutConstraint *backViewTopConstraint;
    
    HTDatePicker *datePicker;
}

@end

@implementation WBMeasuringView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, IPHONE_HEIGHT)];
    if (self) {
        self.backgroundColor = RGB(33,39,40);
        
        alarmView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, 173.0f)];
        alarmView.backgroundColor = [UIColor clearColor];
        [self addSubview:alarmView];
        
        alarmoffLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 43.0f, 200.0f, 16.0f)];
        alarmoffLabel.textAlignment = NSTextAlignmentLeft;
        alarmoffLabel.textColor = RGB(139,138,138);
        alarmoffLabel.backgroundColor = [UIColor clearColor];
        alarmoffLabel.textColor = [UIColor whiteColor];
        alarmoffLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        alarmoffLabel.text = NSLocalizedString(@"ALARM OFF", nil);
        [alarmView addSubview:alarmoffLabel];
        
        alarmTimeLabel = [[UILabel alloc] init];
        alarmTimeLabel.textAlignment = NSTextAlignmentLeft;
        alarmTimeLabel.backgroundColor = [UIColor clearColor];
        alarmTimeLabel.textColor = RGB(139,138,138);
        alarmTimeLabel.font = [UIFont boldSystemFontOfSize:35.0f];
        alarmTimeLabel.text = [NSDate detailDate:[NSDate date]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeTap)];
        alarmTimeLabel.userInteractionEnabled = YES;
        [alarmTimeLabel addGestureRecognizer:tapGesture];
        [alarmView addSubview:alarmTimeLabel];
        [alarmTimeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:alarmoffLabel withOffset:10.0f];
        [alarmTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [alarmTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:25.0f];
        
        alarmSwitch = [[UISwitch alloc] init];
        [alarmView addSubview:alarmSwitch];
        [alarmSwitch autoAlignAxis:ALAxisHorizontal toSameAxisOfView:alarmTimeLabel];
        [alarmSwitch autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25.0f];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 173.0f, IPHONE_WIDTH, 0.5f)];
        lineView.backgroundColor = [UIColor whiteColor];
        [alarmView addSubview:lineView];
        
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor clearColor];
        [self addSubview:backView];
        backViewTopConstraint = [backView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:lineView.bottom];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        
        animationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_measuring_spinner"]];
        [backView addSubview:animationView];
        [animationView autoCenterInSuperview];
        
        measuringLabel = [[UILabel alloc] init];
        measuringLabel.textAlignment = NSTextAlignmentCenter;
        measuringLabel.backgroundColor = [UIColor clearColor];
        measuringLabel.textColor = RGB(149,164,165);
        measuringLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        measuringLabel.text = NSLocalizedString(@"Measuring", nil);
        [backView addSubview:measuringLabel];
        [measuringLabel autoCenterInSuperview];
        
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
        rotationAnimation.duration = 3.5f;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = HUGE_VALF;
        
        stopMeasuringButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [stopMeasuringButton addTarget:self action:@selector(stopMeasuringButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [stopMeasuringButton setTitleColor:RGB(149,164,165) forState:UIControlStateNormal];
        stopMeasuringButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [stopMeasuringButton setBackgroundImage:[UIImage imageNamed:@"button_background_image_night"] forState:UIControlStateNormal];
        [stopMeasuringButton setTitle:NSLocalizedString(@"Stop measuring", nil) forState:UIControlStateNormal];
        [backView addSubview:stopMeasuringButton];
        [stopMeasuringButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [stopMeasuringButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [stopMeasuringButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [stopMeasuringButton autoSetDimension:ALDimensionHeight toSize:43.0f];
        
        datePicker = [[HTDatePicker alloc] initWithFrame:CGRectMake(0, self.height, IPHONE_WIDTH, 260) date:[NSDate date]];
        datePicker.hidden = YES;
        datePicker.delegate = self;
        [self addSubview:datePicker];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataAnalysingFinished) name:WBDataAnalysingFinishedNotification object:nil];
        
    }
    
    return self;
    
}

- (void)reset {
    self.top = 0.0f;
    alarmView.hidden = NO;
    measuringLabel.text = NSLocalizedString(@"Measuring", nil);
    backViewTopConstraint.constant = lineView.bottom;
    stopMeasuringButton.enabled = YES;
    
    [self updateConstraintsIfNeeded];
}

- (void)startAnimation {
    [animationView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimation {
    [animationView.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)timeTap {
    [self showDatePicker:datePicker.hidden];
}

- (void)dataAnalysingFinished {
    [[GCDQueue mainQueue] queueBlock:^{
        if (!datePicker.hidden) {
            [self showDatePicker:NO];
        }
        [self alertView:nil clickedButtonAtIndex:0];
    }];
}

- (void)stopMeasuringButtonClick {
    stopMeasuringButton.enabled = NO;
    
    if (BLEShareInstance.activePeripheral) {
        [[BLEShareInstance CM] cancelPeripheralConnection:BLEShareInstance.activePeripheral];
    }
    
    alarmView.hidden = YES;
    measuringLabel.text = NSLocalizedString(@"Analyzing", nil);
    backViewTopConstraint.constant = 0.0f;
    
    [self updateConstraintsIfNeeded];
    
    [[GCDQueue globalQueue] queueBlock:^{
      [[WBDataOperation shareInstance] stopSleep];
    }];

}

- (void)bleDidDisconnect {
    if (!stopMeasuringButton.enabled) {
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:@"Measurements were stopped due to lost sensor connection" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [UIView animateWithDuration:0.35f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.superview.top = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         
                         [self stopAnimation];
                         [self reset];
                     }
     ];
}

#pragma mark - HTDatePickerDelegate

- (void)datePickerCancel {
    [self showDatePicker:NO];
}

- (void)datePickerFinished:(NSDate *)date {
    alarmTimeLabel.text = [NSDate detailDate:date];
    [self showDatePicker:NO];
}

- (void)showDatePicker:(BOOL)show {
    datePicker.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        if (show) {
            datePicker.top = self.height - datePicker.height;
        } else {
            datePicker.top = self.height;
        }
    } completion:^(BOOL finished) {
        if (!show) {
            datePicker.hidden = YES;
        }
    }];
}

@end
