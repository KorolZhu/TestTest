//
//  WBCollectionViewCell.h
//  WristBand
//
//  Created by zhuzhi on 14/11/10.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBMainView.h"

@class WBSleepInfo;

@interface WBCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)WBSleepInfo *sleepInfo;
@property (nonatomic,weak)UIViewController *superViewController;
@property (nonatomic,weak)id <WBMainViewDelegate> scrollDelegate;

- (void)configCell;

@end
