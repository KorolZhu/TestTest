//
//  WBCircleView.h
//  WristBand
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBCircleView : UIView

@property (nonatomic,assign)NSInteger totalScore;

@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UITapGestureRecognizer *tapGestureRecognizer;

- (void)reloadData;
- (void)invalidate;

@end
