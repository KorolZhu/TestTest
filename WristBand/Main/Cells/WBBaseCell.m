//
//  WBBaseCell.m
//  WristBand
//
//  Created by zhuzhi on 14/11/9.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBBaseCell.h"

@implementation WBBaseCell

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, 0.0f)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)configCell {
    
}

- (CGFloat)cellHeight {
    return 0.0f;
}

@end
