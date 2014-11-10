//
//  WBCollectionViewCell.m
//  WristBand
//
//  Created by zhuzhi on 14/11/10.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBCollectionViewCell.h"
#import "WBSleepInfo.h"

@interface WBCollectionViewCell ()
{
    WBMainView *mainView;
}

@end

@implementation WBCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mainView = [[WBMainView alloc] init];
        [self.contentView addSubview:mainView];
        [mainView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    
    return self;
}

- (void)setScrollDelegate:(id<WBMainViewDelegate>)scrollDelegate {
    _scrollDelegate = scrollDelegate;
    mainView.scrollDelegate = _scrollDelegate;
}

- (void)setSuperViewController:(UIViewController *)superViewController {
    _superViewController = superViewController;
    mainView.superViewController = superViewController;
}

- (void)setSleepInfo:(WBSleepInfo *)sleepInfo {
    _sleepInfo = sleepInfo;
    mainView.sleepInfo = sleepInfo;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    mainView.sleepInfo = nil;
    if (!CGPointEqualToPoint(mainView.contentOffset, CGPointZero)) {
        [mainView setContentOffset:CGPointZero animated:NO];
    }
    [mainView prepareForReuse];
}

- (void)configCell {
    [mainView reuse];
    [mainView reloadData];
}

@end
