//
//  WBLineChartView.m
//  ChartViewController
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import "WBLineChartView.h"
#import "PureLayout.h"
#import "WBSleepPoint.h"

CGFloat static const kWBChartViewLeft = 40.0f;
CGFloat static const kWBChartViewWidth = 60.0f;
CGFloat static const kWBChartViewHeight = 65.0f;
CGFloat static const kWBVerticalSeperateViewWidth = 15.0f;

@interface WBLineChartView ()
{
    CGRect deepSleepVerticalLineFrame;
}

@property (nonatomic)NSInteger startHour;
@property (nonatomic)NSInteger endHour;
@property (nonatomic)NSInteger totalHour;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *deepSleepLabel;

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
        
        _deepSleepLabel = [[UILabel alloc] init];
        _deepSleepLabel.numberOfLines = 0;
        _deepSleepLabel.backgroundColor = [UIColor clearColor];
        _deepSleepLabel.font = [UIFont systemFontOfSize:11.0f];
        _deepSleepLabel.textColor = RGB(87,104,106);
        _deepSleepLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_deepSleepLabel];
    }
    return self;
}

- (void)reloadData {
    _titleLabel.text = self.title;
    [_titleLabel sizeToFit];
    _titleLabel.centerX = self.centerX;
    _titleLabel.top = 10.0f;


    _deepSleepLabel.text = NSLocalizedString(@"DEEP\nSLEEP", nil);
    [_deepSleepLabel sizeToFit];
    _deepSleepLabel.centerX = kWBChartViewLeft + kWBChartViewWidth - kWBVerticalSeperateViewWidth / 2.0f;
    _deepSleepLabel.top = _titleLabel.bottom + 10.0f;
    
    NSInteger section = [self.dataSource numberOfSectionsInLineChartView:self];
    NSArray *array = [self.dataSource lineChartView:self sleepInfosAtSection:0];
    if (array.count > 0) {
        WBSleepPoint *sleepInfo = array.firstObject;
        self.startHour = sleepInfo.hour;
    }
    
    array = [self.dataSource lineChartView:self sleepInfosAtSection:section - 1];
    if (array.count > 0) {
        WBSleepPoint *sleepInfo = array.lastObject;
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
	if (totalHour == 0) {
		totalHour = 1;
	}
    self.totalHour = totalHour;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    deepSleepVerticalLineFrame.origin.x = kWBChartViewLeft + kWBChartViewWidth - kWBVerticalSeperateViewWidth;
    deepSleepVerticalLineFrame.origin.y = _deepSleepLabel.bottom + 5.0f;
    deepSleepVerticalLineFrame.size.width = kWBVerticalSeperateViewWidth;
    deepSleepVerticalLineFrame.size.height = self.totalHour * kWBChartViewHeight;
    
    CGFloat height = CGRectGetMaxY(deepSleepVerticalLineFrame) + 15.0f;
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
    [self setNeedsDisplay];
    
    [self drawSegementTime];
}

- (CGPoint)calculateMidPointForPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    return CGPointMake((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0);
}

- (CGPoint)pointForSleepInfo:(WBSleepPoint *)info {
    CGPoint point = CGPointZero;
    point.x = kWBChartViewLeft + kWBChartViewWidth / 30.0f * info.sleepValue;
    
    NSInteger totalHour = 0;
    NSInteger currentHour = info.hour;
    if (self.startHour > currentHour) {
        totalHour += 24 - self.startHour;
        totalHour += currentHour;
    } else {
        totalHour += currentHour - self.startHour;
    }
    
    CGFloat y = 0.0f;
    y += totalHour / (double)self.totalHour * CGRectGetHeight(deepSleepVerticalLineFrame);
    y += info.minute / 60.0f * kWBChartViewHeight;
    y += CGRectGetMinY(deepSleepVerticalLineFrame);
    
    point.y = y;
    return point;
}

- (void)drawSegementTime {
    
    for (UIView *view in self.subviews) {
        if (view.tag == 900) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat bottom = 0.0f;
    
    WBSleepInfo *sleepInfo = [self.dataSource sleepInfoOfLineChartView:self];
    if (sleepInfo.toBedTimeString.length > 0) {
        WBSleepPoint *info = [[WBSleepPoint alloc] init];
        info.time = sleepInfo.toBedTime;
        
        CGPoint point = [self pointForSleepInfo:info];
        UILabel *label = [[UILabel alloc] init];
        label.tag = 900;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = RGB(175,176,161);
        label.font = [UIFont systemFontOfSize:12.0f];
        label.layer.cornerRadius = 5.0f;
        label.clipsToBounds = YES;
        label.text = sleepInfo.toBedTimeString;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        label.left = kWBChartViewLeft + kWBChartViewWidth + 30.0f;
        label.top = point.y - 17.0f;
        label.width = IPHONE_WIDTH - label.left - 35.0f;
        label.height = 35.0f;
        
        bottom = label.bottom;
    }
    
    if (sleepInfo.fallAsleepInTimeString.length > 0) {
        WBSleepPoint *info = [[WBSleepPoint alloc] init];
        info.time = sleepInfo.fallAsleepTime;
        
        CGPoint point = [self pointForSleepInfo:info];
        UILabel *label = [[UILabel alloc] init];
        label.tag = 900;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = RGB(63,164,192);
        label.font = [UIFont systemFontOfSize:12.0f];
        label.layer.cornerRadius = 5.0f;
        label.clipsToBounds = YES;
        label.text = sleepInfo.fallAsleepInTimeString;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        label.left = kWBChartViewLeft + kWBChartViewWidth + 30.0f;
        label.top = point.y - 17.0f;
        if (label.top < bottom) {
            label.top = bottom + 5.0f;
        }
        label.width = IPHONE_WIDTH - label.left - 35.0f;
        label.height = 35.0f;
        
        bottom = label.bottom;
    }
    
    if (sleepInfo.gotupString.length > 0) {
        WBSleepPoint *info = [[WBSleepPoint alloc] init];
        info.time = sleepInfo.gotupTime;
        
        CGPoint point = [self pointForSleepInfo:info];
        UILabel *label = [[UILabel alloc] init];
        label.tag = 900;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.layer.cornerRadius = 5.0f;
        label.clipsToBounds = YES;
        label.text = sleepInfo.gotupString;
        label.textColor = [UIColor grayColor];
        [self addSubview:label];
        label.left = kWBChartViewLeft + kWBChartViewWidth + 30.0f;
        label.top = point.y - 17.0f;
        if (label.top < bottom) {
            label.top = bottom + 5.0f;
        }
        label.width = IPHONE_WIDTH - label.left - 35.0f;
        label.height = 35.0f;
    }
    
    
    
//    for (int i = 0; i < [self.dataSource numberOfSectionsInLineChartView:self]; i++) {
//        NSArray *arr = [self.dataSource lineChartView:self sleepInfosAtSection:i];
//        if (arr.count >= 1) {
//            WBSleepPoint *info = arr.firstObject;
//            if (info.state == WBSleepStageTypeAway) {
//                continue;
//            }
//            CGPoint point = [self pointForSleepInfo:info];
//            UILabel *label = [[UILabel alloc] init];
//            label.tag = 900;
//            label.textAlignment = NSTextAlignmentCenter;
//            label.backgroundColor = [self.dataSource lineChartView:self fillColorAtSection:i];
//            label.font = [UIFont systemFontOfSize:12.0f];
//            label.layer.cornerRadius = 5.0f;
//            label.clipsToBounds = YES;
//            if (info.state == WBSleepStageTypeAwake) {
//                label.text =  @"To bed 18:30";
//            } else {
//                label.text = @"Fall asleep in 30 min";
//            }
//            label.textColor = [UIColor whiteColor];
//            [self addSubview:label];
//            label.left = kWBChartViewLeft + kWBChartViewWidth + 30.0f;
//            label.top = point.y;
//            label.width = 150.0f;
//            label.height = 35.0f;
//        }
//    }
}

- (NSInteger)sectionForSleepInfo:(WBSleepPoint *)sleepPoint {
    if (!sleepPoint) {
        return -1;
    }
    
    NSInteger section = [self.dataSource numberOfSectionsInLineChartView:self];
    for (int i = 0; i < section; i++) {
        NSArray *sleepPoints = [self.dataSource lineChartView:self sleepInfosAtSection:i];
        if (sleepPoints.lastObject == sleepPoint) {
            return i;
        }
    }
    
    return -1;
}

- (void)drawRect:(CGRect)rect {
    // 画深睡垂直线
    UIBezierPath *deepSleepLine = [UIBezierPath bezierPathWithRect:deepSleepVerticalLineFrame];
    [RGB(197,197,197) setFill];
    [deepSleepLine fill];
    
    // 画时间轴
    for (NSInteger i = 0; i <= self.totalHour; i++) {
        
        UIImage *image = [UIImage imageNamed:i == 0 ? @"timeline_60" : @"timeline_40"];
        [image drawAtPoint:CGPointMake(0.0f, CGRectGetMinY(deepSleepVerticalLineFrame) + i * kWBChartViewHeight)];
        
        NSInteger hour = i + self.startHour;
        if (hour >= 24) {
            hour -= 24;
        }
        [[NSString stringWithFormat:@"%02ld", (long)hour] drawInRect:CGRectMake(5.0f, CGRectGetMinY(deepSleepVerticalLineFrame) + i * kWBChartViewHeight, 30.0f, 20.0f) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]}];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [self.dataSource numberOfSectionsInLineChartView:self]; i++) {
        [array addObjectsFromArray:[self.dataSource lineChartView:self sleepInfosAtSection:i]];
    }
    
    UIBezierPath *bezierpath = [UIBezierPath bezierPath];
    
    __block CGPoint lastEndPoint;
    __block CGPoint currentEndPoint;
    
    __block CGPoint _prePreviousPoint = CGPointZero;
    __block CGPoint _previousPoint = CGPointZero;
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        WBSleepPoint *info = obj;
        CGPoint point = [self pointForSleepInfo:info];
        
        if (idx == 0) {
            lastEndPoint = point;
            
            [bezierpath moveToPoint:point];
            _prePreviousPoint = CGPointMake(kWBChartViewLeft, point.y);
            _previousPoint = point;
            
        } else {
            CGPoint currentPoint = point;
			
			if (currentPoint.x == _previousPoint.x) {
				[bezierpath addLineToPoint:currentPoint];
				_prePreviousPoint = _previousPoint;
				_previousPoint = point;
				
				currentEndPoint = currentPoint;
			} else {
				CGPoint mid1 = [self calculateMidPointForPoint:_previousPoint andPoint:_prePreviousPoint];
				CGPoint mid2 = [self calculateMidPointForPoint:currentPoint andPoint:_previousPoint];
				
				if (idx > 1) {
					[bezierpath addLineToPoint:mid1];
				}
				[bezierpath addQuadCurveToPoint:mid2 controlPoint:_previousPoint];
				
				_prePreviousPoint = _previousPoint;
				_previousPoint = point;
				
				currentEndPoint = mid2;
			}
        }
		
        NSInteger section = [self sectionForSleepInfo:info];
        if (section >= 0) {
            [bezierpath addLineToPoint:CGPointMake(kWBChartViewLeft, currentEndPoint.y)];
            [bezierpath addLineToPoint:CGPointMake(kWBChartViewLeft, lastEndPoint.y)];
            
            lastEndPoint = currentEndPoint;
            
            [[self.dataSource lineChartView:self fillColorAtSection:section] setFill];
            [bezierpath closePath];
            [bezierpath fill];
            
            [bezierpath removeAllPoints];
            [bezierpath moveToPoint:currentEndPoint];
        }
    }];
    
    return;
}

@end
