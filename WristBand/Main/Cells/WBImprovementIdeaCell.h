//
//  WBImprovementIdeaCell.h
//  WristBand
//
//  Created by zhuzhi on 14/11/2.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBImprovementIdeaCell : UITableViewCell

@property (nonatomic,strong)    UIButton *button;

- (void)configCell;
- (CGFloat)cellHeight;

@end
