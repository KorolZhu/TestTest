//
//  WBMeasuringView.h
//  WristBand
//
//  Created by zhuzhi on 14/11/4.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBMeasuringView : UIView

- (void)startAnimation;
- (void)bleDidDisconnect;
- (BOOL)isAnimating;
- (void)dataAnalysingFinished;

@end
