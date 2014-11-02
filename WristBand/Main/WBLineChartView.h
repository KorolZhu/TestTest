//
//  WBLineChartView.h
//  ChartViewController
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBLineChartView;

@protocol WBLineChartViewDataSource <NSObject>

@required

- (NSInteger)numberOfSectionsInLineChartView:(WBLineChartView *)lineChartView;

- (NSArray *)lineChartView:(WBLineChartView *)lineChartView sleepInfosAtSection:(NSUInteger)section;

- (UIColor *)lineChartView:(WBLineChartView *)lineChartView fillColorAtSection:(NSUInteger)section;

@end

@interface WBLineChartView : UIView

@property (nonatomic,weak)id<WBLineChartViewDataSource> dataSource;
@property (nonatomic, retain) NSString *title;
- (void)reloadData;

@end
