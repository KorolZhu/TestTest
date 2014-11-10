//
//  WBMainView.h
//  WristBand
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBSleepInfo;
@class WBMainView;

@protocol WBMainViewDelegate <NSObject>

- (void)mainViewDidScroll:(WBMainView *)mainView;

@end

@interface WBMainView : UITableView

@property (nonatomic,strong)WBSleepInfo *sleepInfo;
@property (nonatomic,weak)UIViewController *superViewController;
@property (nonatomic,weak)id <WBMainViewDelegate> scrollDelegate;

@end
