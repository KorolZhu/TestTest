//
//  WBLineChartView.m
//  ChartViewController
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "WBLineChartView.h"
#import "PureLayout.h"
#import "WBSleepInfo.h"

CGFloat static const kWBChartViewLeft = 40.0f;
CGFloat static const kWBChartViewWidth = 45.0f;
CGFloat static const kWBChartViewHeight = 65.0f;
CGFloat static const kWBVerticalSeperateViewWidth = 15.0f;

@interface WBLineChartView ()
{
    NSLayoutConstraint *seperateHeightConstraint;
}

@property (nonatomic)NSInteger startHour;
@property (nonatomic)NSInteger endHour;
@property (nonatomic)NSInteger totalHour;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *deepSleepLabel;
@property (nonatomic,strong)UIView *verticalSeperateView;

@end

@implementation WBLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _titleLabel.textColor = RGB(87,104,106);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [_titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        _deepSleepLabel = [[UILabel alloc] init];
        _deepSleepLabel.numberOfLines = 0;
        _deepSleepLabel.backgroundColor = [UIColor clearColor];
        _deepSleepLabel.font = [UIFont systemFontOfSize:11.0f];
        _deepSleepLabel.textColor = RGB(87,104,106);
        _deepSleepLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_deepSleepLabel];
        [_deepSleepLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel withOffset:10.0f];
        
        _verticalSeperateView = [[UIView alloc] init];
        _verticalSeperateView.backgroundColor = RGB(197,197,197);
        [self addSubview:_verticalSeperateView];
        [_verticalSeperateView autoSetDimension:ALDimensionWidth toSize:kWBVerticalSeperateViewWidth];
        [_verticalSeperateView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_deepSleepLabel withOffset:5.0f];
        [_verticalSeperateView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWBChartViewLeft + kWBChartViewWidth];
        seperateHeightConstraint = [_verticalSeperateView autoSetDimension:ALDimensionHeight toSize:0.0f];
        [_deepSleepLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:_verticalSeperateView];
    }
    return self;
}

- (void)reloadData {
    self.titleLabel.text = self.title;
    self.deepSleepLabel.text = NSLocalizedString(@"DEEP\nSLEEP", nil);
    
    NSInteger section = [self.dataSource numberOfSectionsInLineChartView:self];
    NSArray *array = [self.dataSource lineChartView:self sleepInfosAtSection:0];
    if (array.count > 0) {
        WBSleepInfo *sleepInfo = array.firstObject;
        self.startHour = sleepInfo.hour;
    }
    
    array = [self.dataSource lineChartView:self sleepInfosAtSection:section - 1];
    if (array.count > 0) {
        WBSleepInfo *sleepInfo = array.lastObject;
        if (sleepInfo.minute > 0) {
            self.endHour = sleepInfo.hour + 1;
        } else {
            self.endHour = sleepInfo.hour;
        }
    }
    
    int totalHour = 0;
    if (self.startHour > self.endHour) {
        totalHour += 24 - self.startHour;
        totalHour += self.endHour;
    } else {
        totalHour += self.endHour - self.startHour;
    }
    self.totalHour = totalHour;
    
    seperateHeightConstraint.constant = self.totalHour * kWBChartViewHeight;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGFloat height = CGRectGetMaxY(_verticalSeperateView.frame) + 15.0f;
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
    [self setNeedsDisplay];
}

- (CGPoint)calculateMidPointForPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    return CGPointMake((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0);
}

- (CGPoint)pointForSleepInfo:(WBSleepInfo *)info {
    CGPoint point = CGPointZero;
    point.x = kWBChartViewLeft + 1.5 * info.sleepValue;
    
    NSInteger totalHour = 0;
    NSInteger currentHour = info.hour;
    if (self.startHour > currentHour) {
        totalHour += 24 - self.startHour;
        totalHour += currentHour;
    } else {
        totalHour += currentHour - self.startHour;
    }
    
    CGFloat y = 0.0f;
    y += totalHour / (double)self.totalHour * CGRectGetHeight(_verticalSeperateView.frame);
    y += info.minute / 60.0f * kWBChartViewHeight;
    y += CGRectGetMinY(_verticalSeperateView.frame);
    
    point.y = y;
    return point;
}

- (void)drawRect:(CGRect)rect {
    // 画时间轴
    for (NSInteger i = 0; i <= self.totalHour; i++) {
        
        UIImage *image = [UIImage imageNamed:i == 0 ? @"timeline_60" : @"timeline_40"];
        [image drawAtPoint:CGPointMake(0.0f, CGRectGetMinY(_verticalSeperateView.frame) + i * kWBChartViewHeight)];
        
        NSInteger hour = i + self.startHour;
        if (hour >= 24) {
            hour -= 24;
        }
        [[NSString stringWithFormat:@"%02ld", (long)hour] drawInRect:CGRectMake(5.0f, CGRectGetMinY(_verticalSeperateView.frame) + i * kWBChartViewHeight, 30.0f, 20.0f) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]}];
    }
    
    
    NSInteger section = [self.dataSource numberOfSectionsInLineChartView:self];
    for (NSInteger i = 0; i < section; i++) {
        
        UIBezierPath *bezierpath = [UIBezierPath bezierPath];
        __block CGPoint _prePreviousPoint = CGPointZero;
        __block CGPoint _previousPoint = CGPointZero;
        
        __block CGFloat firstYPosition;
        __block CGFloat lastYPosition;
        
        NSArray *sleepInfos = [self.dataSource lineChartView:self sleepInfosAtSection:i];
        [sleepInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WBSleepInfo *info = obj;
            CGPoint point = [self pointForSleepInfo:info];
            
            if (idx == 0) {
                firstYPosition = point.y;
                
                [bezierpath moveToPoint:point];
                _prePreviousPoint = CGPointMake(kWBChartViewLeft, point.y);
                _previousPoint = point;

            } else {
                CGPoint currentPoint = point;
                
                CGPoint mid1 = [self calculateMidPointForPoint:_previousPoint andPoint:_prePreviousPoint];
                CGPoint mid2 = [self calculateMidPointForPoint:currentPoint andPoint:_previousPoint];
                
                if (idx > 1) {
                    [bezierpath addLineToPoint:mid1];
                }
                [bezierpath addQuadCurveToPoint:mid2 controlPoint:_previousPoint];
                
                _prePreviousPoint = _previousPoint;
                _previousPoint = point;
                
                if (idx == sleepInfos.count - 1) {
                    lastYPosition = mid2.y;
                }
            }
        }];
        
        [bezierpath addLineToPoint:CGPointMake(kWBChartViewLeft, lastYPosition)];
        [bezierpath addLineToPoint:CGPointMake(kWBChartViewLeft, firstYPosition)];

        UIColor *fillColor = [self.dataSource lineChartView:self fillColorAtSection:i];
        [fillColor setFill];
        [bezierpath closePath];
        [bezierpath fill];
        
//        UIColor *strokeColor = [UIColor blueColor];
//        [strokeColor setStroke];
//        [bezierpath stroke];
    }
}

@end
