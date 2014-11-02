//
//  WBCircleView.m
//  WristBand
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBCircleView.h"

#define KCircleRadius 87.0f
#define KVerticalPadding 10.0f

@interface WBCircleView ()
{
    UIBezierPath *bezierPath;
    CAShapeLayer *arcLayer;
    
    UIImageView *backImageView;
    UIImageView *achievementView;
    UILabel *totalScoreLabel;
    UILabel *scroeDetailLabel;
}

@end

@implementation WBCircleView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"center_image_default"]];
        backImageView.userInteractionEnabled = YES;
        [backImageView setHighlightedImage:[UIImage imageNamed:@"center_image_pressed"]];
        [self addSubview:backImageView];
        [backImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [backImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:KVerticalPadding];
        
        achievementView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sleep_achievement_icon"]];
        [self addSubview:achievementView];
        [achievementView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset: KVerticalPadding];
        [achievementView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        achievementView.hidden = YES;
        
        totalScoreLabel = [[UILabel alloc] init];
        totalScoreLabel.textAlignment = NSTextAlignmentCenter;
        totalScoreLabel.backgroundColor = [UIColor clearColor];
        totalScoreLabel.font = [UIFont systemFontOfSize:52.0f];
        totalScoreLabel.textColor = RGB(87,104,106);
        totalScoreLabel.text = @"112";
        [self addSubview:totalScoreLabel];
        [totalScoreLabel autoSetDimension:ALDimensionWidth toSize:2 * KCircleRadius];
        [totalScoreLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [totalScoreLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        scroeDetailLabel = [[UILabel alloc] init];
        scroeDetailLabel.numberOfLines = 0;
        scroeDetailLabel.textAlignment = NSTextAlignmentCenter;
        scroeDetailLabel.backgroundColor = [UIColor clearColor];
        scroeDetailLabel.font = [UIFont systemFontOfSize:17.0f];
        scroeDetailLabel.textColor = RGB(87,104,106);
        scroeDetailLabel.text = @"TOTAL SLEEP SCORE";
        [self addSubview:scroeDetailLabel];
        [scroeDetailLabel autoSetDimension:ALDimensionWidth toSize:2 * KCircleRadius - 40.0f];
        [scroeDetailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:totalScoreLabel withOffset:10.0f];
        [scroeDetailLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    }
    return self;
}

- (void)startAnimating {
    if (!bezierPath) {
        bezierPath = [UIBezierPath bezierPath];
        [bezierPath addArcWithCenter:CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f + KVerticalPadding) radius:87.0f + 6.0f startAngle:- M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    }
    
    if (!arcLayer) {
        arcLayer=[CAShapeLayer layer];
        arcLayer.path = bezierPath.CGPath;
        arcLayer.fillColor = [[UIColor clearColor] CGColor];
        arcLayer.strokeColor = [RGB(63,164,193) CGColor];
        arcLayer.lineWidth = 10.0f;
        arcLayer.frame=self.bounds;
        [self.layer insertSublayer:arcLayer below:achievementView.layer];
        [self drawLineAnimation:arcLayer];
    }
}


-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 0.7f;
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    achievementView.hidden = NO;
}

@end
