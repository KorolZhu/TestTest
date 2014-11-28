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
#import "WBHeartRateCell.h"
#import "WBBreathRateCell.h"
#import "WBLineChartView.h"
#import "WBImprovementViewController.h"
#import "WBSleepInfo.h"
#import "WBSleepPoint.h"

@interface WBMainView ()<UITableViewDataSource,UITableViewDelegate,WBLineChartViewDataSource>
{
    UIView *tableHeaderView;
    UILabel *titleLabel;
    UIView *lineView;
    
    UITableViewCell *circleCell;
    WBScoreDetailCell *scoreDetailCell;
    WBImprovementIdeaCell *improvementCell;
    WBTotalSleepTimeCell *sleepTimeCell;
    WBHeartRateCell *heartRateCell;
    WBBreathRateCell *breathRateCell;
    UITableViewCell *chartCell;
    WBLineChartView *lineChartView;
    WBCircleView *circleView;
    
    BOOL showScoreDetail;
}

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
		
		scoreDetailCell = [[WBScoreDetailCell alloc] init];
		scoreDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		improvementCell = [[WBImprovementIdeaCell alloc] init];
		[improvementCell.button addTarget:self action:@selector(improvementClick) forControlEvents:UIControlEventTouchUpInside];
		improvementCell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		sleepTimeCell = [[WBTotalSleepTimeCell alloc] init];
		sleepTimeCell.selectionStyle = UITableViewCellSelectionStyleNone;
		
        heartRateCell = [[WBHeartRateCell alloc] init];
        heartRateCell.selectionStyle = UITableViewCellSelectionStyleNone;

        breathRateCell = [[WBBreathRateCell alloc] init];
        breathRateCell.selectionStyle = UITableViewCellSelectionStyleNone;

		chartCell = [[UITableViewCell alloc] init];
		chartCell.selectionStyle = UITableViewCellSelectionStyleNone;
		chartCell.backgroundColor = [UIColor clearColor];
		
		lineChartView = [[WBLineChartView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, IPHONE_WIDTH - 20.0f, 0.0f)];
		lineChartView.dataSource = self;
		lineChartView.title = NSLocalizedString(@"Night overview", nil);
		
		[chartCell.contentView addSubview:lineChartView];

    }
    return self;
}

- (void)improvementClick {
    WBImprovementViewController *viewController = [[WBImprovementViewController alloc] init];
    [self.superViewController.containViewController addChildViewController:viewController];
    [viewController willMoveToParentViewController:self.superViewController.containViewController];
    
    [self.superViewController.containViewController transitionFromViewController:self.superViewController toViewController:viewController duration:0.55f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
    } completion:NULL];
}

- (void)circleClick {
    showScoreDetail = !showScoreDetail;
    [self reloadData];
    if (showScoreDetail) {
        [self scrollRectToVisible:CGRectMake(0.0f, circleCell.centerY + 45.0f, IPHONE_WIDTH, self.height) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = tableHeaderView.frame;
    if (scrollView.contentOffset.y < 0) {
        frame.origin.y = scrollView.contentOffset.y;
    } else {
        frame.origin.y = 0.0f;
    }
    tableHeaderView.frame = frame;
    
    [self.scrollDelegate mainViewDidScroll:self];
}

- (void)prepareForReuse {
    [circleView invalidate];
    showScoreDetail = NO;
}

- (void)reuse {
    circleView.totalScore = _sleepInfo.sleepScore.totalScore;
    [circleView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [self improvementClick];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (!circleCell) {
            circleCell = [[UITableViewCell alloc] init];
            circleCell.backgroundColor = [UIColor clearColor];
            circleCell.contentView.backgroundColor = [UIColor clearColor];
            circleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            circleView = [[WBCircleView alloc] init];
            [circleView.tapGestureRecognizer addTarget:self action:@selector(circleClick)];
            [circleCell.contentView addSubview:circleView];
			[circleView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:44.0f];
            [circleView autoSetDimensionsToSize:CGSizeMake(220.0f, 220.0f)];
            [circleView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [circleCell setNeedsLayout];
            [circleCell layoutIfNeeded];
            
            circleView.totalScore = self.sleepInfo.sleepScore.totalScore;
            [circleView reloadData];
        }
        
        return circleCell;
    }
    
    if (indexPath.row == 1) {
        return scoreDetailCell;
    }
    
    if (indexPath.row == 2) {
        return improvementCell;
    }
    
    if (indexPath.row == 3) {
        return sleepTimeCell;
    }
    
    if (indexPath.row == 4) {
        return heartRateCell;
    }
    
    if (indexPath.row == 5) {
        return breathRateCell;
    }
    
    if (indexPath.row == 6) {
        return chartCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 264.0f;
    }
    
    if (indexPath.row == 1) {
        if (!showScoreDetail) {
            scoreDetailCell.hidden = YES;
            return 0.0f;
        } else {
            scoreDetailCell.hidden = NO;
            scoreDetailCell.sleepInfo = self.sleepInfo;
            [scoreDetailCell configCell];
            return [scoreDetailCell cellHeight];
        }
    }
    
    if (indexPath.row == 2) {
        improvementCell.sleepInfo = self.sleepInfo;
        [improvementCell configCell];
        return [improvementCell cellHeight];
    }
    
    if (indexPath.row == 3) {
        sleepTimeCell.sleepInfo = self.sleepInfo;
        [sleepTimeCell configCell];
        return [sleepTimeCell cellHeight];
    }
    
    if (indexPath.row == 4) {
        heartRateCell.sleepInfo = self.sleepInfo;
        [heartRateCell configCell];
        return [heartRateCell cellHeight];
    }
    
    if (indexPath.row == 5) {
        breathRateCell.sleepInfo = self.sleepInfo;
        [breathRateCell configCell];
        return [breathRateCell cellHeight];
    }
    
    if (indexPath.row == 6) {
        [lineChartView reloadData];
        return lineChartView.height + 10.0f;
    }
    
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1f;
}

#pragma mark - Line chart data

- (NSInteger)numberOfSectionsInLineChartView:(WBLineChartView *)lineChartView {
    return self.sleepInfo.sleepPoints.count;
}

- (NSArray *)lineChartView:(WBLineChartView *)lineChartView sleepInfosAtSection:(NSUInteger)section {
    NSArray *array = [self.sleepInfo.sleepPoints objectAtIndex:section];
    return array;
}

- (UIColor *)lineChartView:(WBLineChartView *)lineChartView fillColorAtSection:(NSUInteger)section {
    NSArray *array = [self.sleepInfo.sleepPoints objectAtIndex:section];
    if (array.count > 0) {
        WBSleepPoint *point = array.firstObject;
        switch (point.state) {
            case WBSleepStageTypeAway:
                return [UIColor whiteColor];
                break;
            case WBSleepStageTypeAwake:
                return RGB(175,176,160);
                break;
            case WBSleepStageTypeFallasleepDeep:
			case WBSleepStageTypeFallasleepLight:
                return RGB(63,164,191);
                break;
            default:
                break;
        }
    }
    
    return [UIColor yellowColor];
}

@end
