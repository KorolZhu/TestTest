//
//  WBImprovementIdeaCell.m
//  WristBand
//
//  Created by zhuzhi on 14/11/2.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBImprovementIdeaCell.h"

@interface WBImprovementIdeaCell ()
{
    UIImageView *bulbView;
    UILabel *titleLabel;
    UIImageView *arrowRightView;
}

@end

@implementation WBImprovementIdeaCell

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, IPHONE_WIDTH, 0.0f)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        bulbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_idea"]];
        [self.contentView addSubview:bulbView];
        [bulbView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        titleLabel.textColor = RGB(87,104,106);
        titleLabel.text = NSLocalizedString(@"Improvement ideas:", nil);
        [self.contentView addSubview:titleLabel];
        [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:bulbView withOffset:6.0f];
        [titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:bulbView];
        
        UIImage *image = [[UIImage imageNamed:@"checkbox_smart_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
        UIImage *highLightImage = [[UIImage imageNamed:@"checkbox_smart_normal_disabled"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_button setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 12.0f, 0.0f, 0.0f)];
        [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_button setBackgroundImage:image forState:UIControlStateNormal];
        [_button setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
        _button.layer.cornerRadius = 5.0f;
        _button.clipsToBounds = YES;
        [self.contentView addSubview:_button];
        [_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:10.0f];
        [_button autoSetDimension:ALDimensionHeight toSize:80.0f];
        [_button autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_button autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        
        arrowRightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_right_white"]];
        [self.contentView addSubview:arrowRightView];
        [arrowRightView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_button withOffset:-10.0f];
        [arrowRightView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_button];
    }
    
    return self;
}

- (void)configCell {
    [_button setTitle:NSLocalizedString(@"Excrcise regularly", nil) forState:UIControlStateNormal];
}

- (CGFloat)cellHeight {
    [self configCell];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    return _button.bottom + 20.0f;
}

@end
