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

@end

@implementation WBCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _mainView = [[WBMainView alloc] init];
        [self.contentView addSubview:_mainView];
        [_mainView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    
    return self;
}

- (void)setScrollDelegate:(id<WBMainViewDelegate>)scrollDelegate {
    _scrollDelegate = scrollDelegate;
    _mainView.scrollDelegate = _scrollDelegate;
}

- (void)setSuperViewController:(UIViewController *)superViewController {
    _superViewController = superViewController;
    _mainView.superViewController = superViewController;
}

- (void)setSleepInfo:(WBSleepInfo *)sleepInfo {
    _sleepInfo = sleepInfo;
    _mainView.sleepInfo = sleepInfo;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _mainView.sleepInfo = nil;
    if (!CGPointEqualToPoint(_mainView.contentOffset, CGPointZero)) {
        [_mainView setContentOffset:CGPointZero animated:NO];
    }
    [_mainView prepareForReuse];
}

- (void)configCell {
    [_mainView reuse];
    [_mainView reloadData];
}

@end
