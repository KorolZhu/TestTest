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

#define KPaddingAngle M_PI_2 / 30.0f

@interface WBCircleView ()
{
    UIBezierPath *bezierPath;
    CAShapeLayer *arcLayer;
    CGFloat firstEndAngle;
    
    UIBezierPath *bezierPath2;
    CAShapeLayer *arcLayer2;
    
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
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"center_image_default"]];
        _backImageView.userInteractionEnabled = YES;
        [_backImageView setHighlightedImage:[UIImage imageNamed:@"center_image_pressed"]];
        [self addSubview:_backImageView];
        [_backImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_backImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:KVerticalPadding];
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        [_backImageView addGestureRecognizer:_tapGestureRecognizer];
        
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

- (void)setTotalScore:(NSInteger)totalScore {
    _totalScore = totalScore;
//    _totalScore = 90;
    if (_totalScore < 0) {
        _totalScore = 0;
    }
    totalScoreLabel.text = @(_totalScore).stringValue;
}

- (void)reloadData {
    totalScoreLabel.text = @(_totalScore).stringValue;
    [self startAnimating];
}

- (void)invalidate {
    totalScoreLabel.text = nil;
    achievementView.hidden = YES;

    [arcLayer removeFromSuperlayer];
    [arcLayer2 removeFromSuperlayer];
    
    arcLayer = nil;
    arcLayer2 = nil;
    
    bezierPath = nil;
    bezierPath2 = nil;
}

- (void)startAnimating {
    if (!bezierPath) {
        bezierPath = [UIBezierPath bezierPath];
        if (self.totalScore >= 100) {
            firstEndAngle = M_PI * 3 / 2;
        } else {
            firstEndAngle = self.totalScore / 100.0f * M_PI * 2 - M_PI_2;
        }
        [bezierPath addArcWithCenter:CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f + KVerticalPadding) radius:87.0f + 5.0f startAngle:- M_PI_2 endAngle:firstEndAngle  clockwise:YES];
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

- (void)startAnimating2 {
    if (!bezierPath2) {
        bezierPath2 = [UIBezierPath bezierPath];
        CGFloat startAngle = firstEndAngle + (_totalScore == 0 ? 0 : KPaddingAngle);
        CGFloat endAngle = M_PI_2 * 3 -  (_totalScore == 0 ? 0 : KPaddingAngle);
        if (endAngle < startAngle) {
            return;
        }
        
        [bezierPath2 addArcWithCenter:CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f + KVerticalPadding) radius:87.0f + 5.0f startAngle:startAngle endAngle:endAngle  clockwise:YES];
    }
    
    if (!arcLayer2) {
        arcLayer2=[CAShapeLayer layer];
        arcLayer2.path = bezierPath2.CGPath;
        arcLayer2.fillColor = [[UIColor clearColor] CGColor];
        arcLayer2.strokeColor = [RGB(122,128,141) CGColor];
        arcLayer2.lineWidth = 10.0f;
        arcLayer2.frame=self.bounds;
        [self.layer insertSublayer:arcLayer2 below:achievementView.layer];
        [self drawLineAnimation2:arcLayer2];
    }
}


-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.duration = _totalScore == 0 ? 0.0f : 0.7f;
    basicAnimation.delegate = self;
    basicAnimation.fromValue = [NSNumber numberWithInteger:0];
    basicAnimation.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:basicAnimation forKey:@"key"];
}

-(void)drawLineAnimation2:(CALayer*)layer
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.duration = 0.7f;
    basicAnimation.delegate = self;
    basicAnimation.fromValue = [NSNumber numberWithInteger:0];
    basicAnimation.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:basicAnimation forKey:@"key2"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([arcLayer animationForKey:@"key"] == anim) {
        if (self.totalScore >= 100) {
            achievementView.hidden = NO;
        } else {
            [self startAnimating2];
        }
        
        [arcLayer removeAllAnimations];
    }
}

@end
