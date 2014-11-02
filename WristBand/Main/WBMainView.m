//
//  WBMainView.m
//  WristBand
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBMainView.h"
#import "WBCircleView.h"
#import "WBScoreDetailCell.h"
#import "WBImprovementIdeaCell.h"
#import "WBTotalSleepTimeCell.h"
#import "WBLineChartView.h"
#import "WBSleepInfo.h"

@interface WBMainView ()<UITableViewDataSource,UITableViewDelegate,WBLineChartViewDataSource>
{
    UIView *tableHeaderView;
    UILabel *titleLabel;
    UIView *lineView;
    
    UITableViewCell *circleCell;
    WBScoreDetailCell *scoreDetailCell;
    WBImprovementIdeaCell *improvementCell;
    WBTotalSleepTimeCell *sleepTimeCell;
    UITableViewCell *chartCell;
    WBLineChartView *lineChartView;
    
    BOOL showScoreDetail;
}

@property (nonatomic,strong)NSArray *lineChardataSource;

@end

@implementation WBMainView

- (instancetype)init {
    self = [super initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    if (self) {
        self.backgroundColor = RGB(215,222,223);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
        
        tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 44.0f)];
        tableHeaderView.backgroundColor = RGB(236,239,239);
        titleLabel = [[UILabel alloc] initWithFrame:tableHeaderView.bounds];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:25.0f];
        titleLabel.textColor = RGB(87,104,106);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        titleLabel.text = [dateFormatter stringFromDate:[NSDate date]];
        [tableHeaderView addSubview:titleLabel];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake((tableHeaderView.width - 154.0f) / 2.0f, tableHeaderView.height - 2.0f, 154.0f, 2.0f)];
        lineView.backgroundColor = RGB(239,94,0);
        [tableHeaderView addSubview:lineView];
        
        [self addSubview:tableHeaderView];
        [self setScrollIndicatorInsets:UIEdgeInsetsMake(44.0f, 0.0f, 0.0f, 0.0f)];
        
        showScoreDetail = YES;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = tableHeaderView.frame;
    if (scrollView.contentOffset.y < 0) {
        frame.origin.y = scrollView.contentOffset.y;
    } else {
        frame.origin.y = 0.0f;
    }
    tableHeaderView.frame = frame;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (!circleCell) {
            circleCell = [[UITableViewCell alloc] init];
            circleCell.backgroundColor = [UIColor clearColor];
            circleCell.contentView.backgroundColor = [UIColor clearColor];
            circleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            WBCircleView *circleView = [[WBCircleView alloc] init];
            [circleCell.contentView addSubview:circleView];
            [circleView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [circleView autoSetDimensionsToSize:CGSizeMake(220.0f, 220.0f)];
            [circleView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [circleCell setNeedsLayout];
            [circleCell layoutIfNeeded];
            
            [circleView startAnimating];
        }
        return circleCell;
    }
    
    if (indexPath.row == 1) {
        if (!scoreDetailCell) {
            scoreDetailCell = [[WBScoreDetailCell alloc] init];
            scoreDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return scoreDetailCell;
    }
    
    if (indexPath.row == 2) {
        if (!improvementCell) {
            improvementCell = [[WBImprovementIdeaCell alloc] init];
            improvementCell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        return improvementCell;
    }
    
    if (indexPath.row == 3) {
        if (!sleepTimeCell) {
            sleepTimeCell = [[WBTotalSleepTimeCell alloc] init];
            sleepTimeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return sleepTimeCell;
    }
    
    if (indexPath.row == 4) {
        if (!chartCell) {
            chartCell = [[UITableViewCell alloc] init];
            chartCell.selectionStyle = UITableViewCellSelectionStyleNone;
            chartCell.backgroundColor = [UIColor clearColor];
            
            [self initDummyData];
            
            lineChartView = [[WBLineChartView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, IPHONE_WIDTH - 20.0f, 0.0f)];
            lineChartView.dataSource = self;
            lineChartView.title = NSLocalizedString(@"Night overview", nil);
            
            [chartCell.contentView addSubview:lineChartView];
        }
        return chartCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 230.0f;
    }
    
    if (indexPath.row == 1) {
        if (!showScoreDetail) {
            return 0.0f;
        } else {
            return [scoreDetailCell cellHeight];
        }
    }
    
    if (indexPath.row == 2) {
        return [improvementCell cellHeight];
    }
    
    if (indexPath.row == 3) {
        return [sleepTimeCell cellHeight];
    }
    
    if (indexPath.row == 4) {
        [lineChartView reloadData];
        return lineChartView.height + 10.0f;
    }
    
    return 40.0f;
}

#pragma mark - Line chart

- (void)initDummyData {
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableArray *normalArray = [NSMutableArray array];
    NSMutableArray *inbedArray = [NSMutableArray array];
    NSMutableArray *fallAsleepArray = [NSMutableArray array];
    
    NSDate *date = [NSDate dateWithTimeInterval:-28 * 3600 sinceDate:[NSDate date]];
    for (int i = 0; i  < 15 * 60; i+=10) {
        WBSleepInfo *sleepInfo = [[WBSleepInfo alloc] init];
        sleepInfo.time = [[date dateByAddingTimeInterval:i * 60] timeIntervalSince1970];
        if (i < 160) {
            sleepInfo.state = WBSleepInfoStateNormal;
            [normalArray addObject:sleepInfo];
        } else if (i < 320) {
            sleepInfo.state = WBSleepInfoStateInbed;
            [inbedArray addObject:sleepInfo];
        } else {
            sleepInfo.state = WBSleepInfoStateFallAsleep;
            [fallAsleepArray addObject:sleepInfo];
        }
        
        sleepInfo.sleepValue = arc4random() % 30;
        NSLog(@"sleep value = %f", sleepInfo.sleepValue);
    }
    [array addObject:normalArray];
    [array addObject:inbedArray];
    [array addObject:fallAsleepArray];
    
    
    self.lineChardataSource = [NSArray arrayWithArray:array];
}

- (NSInteger)numberOfSectionsInLineChartView:(WBLineChartView *)lineChartView {
    return self.lineChardataSource.count;
}

- (NSArray *)lineChartView:(WBLineChartView *)lineChartView sleepInfosAtSection:(NSUInteger)section {
    NSArray *array = [self.lineChardataSource objectAtIndex:section];
    return array;
}

- (UIColor *)lineChartView:(WBLineChartView *)lineChartView fillColorAtSection:(NSUInteger)section {
    NSArray *array = [self.lineChardataSource objectAtIndex:section];
    if (array.count > 0) {
        WBSleepInfo *info = array.firstObject;
        switch (info.state) {
            case WBSleepInfoStateNormal:
                return [UIColor whiteColor];
                break;
            case WBSleepInfoStateInbed:
                return [UIColor lightGrayColor];
                break;
            case WBSleepInfoStateFallAsleep:
                return [UIColor blueColor];
                break;
            default:
                break;
        }
    }
    
    return [UIColor yellowColor];
}

@end
