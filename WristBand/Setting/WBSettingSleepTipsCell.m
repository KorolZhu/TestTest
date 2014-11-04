//
//  WBSettingSleepTipsCell.m
//  WristBand
//
//  Created by zhuzhi on 14/11/3.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBSettingSleepTipsCell.h"

@interface WBSettingSleepTipsCell ()
{
    UIView *backView;
    UILabel *desLabel;
}

@end

@implementation WBSettingSleepTipsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.text = NSLocalizedString(@"SLEEP COACHING TIPS", nil);
        [self.contentView addSubview:label];
        [label autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor clearColor];
        backView.layer.borderColor = [[UIColor whiteColor] CGColor];
        backView.layer.borderWidth = 0.5f;
        backView.layer.cornerRadius = 6.0f;
        [self.contentView addSubview:backView];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:25.0f];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [backView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        
        UILabel *generalLabel = [[UILabel alloc] init];
        generalLabel.backgroundColor = [UIColor clearColor];
        generalLabel.textColor = [UIColor whiteColor];
        generalLabel.font = [UIFont systemFontOfSize:16.0f];
        generalLabel.text = NSLocalizedString(@"General", nil);
        [backView addSubview:generalLabel];
        [generalLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12.0f];
        [generalLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        
        UISwitch *switch1 = [[UISwitch alloc] init];
        [backView addSubview:switch1];
        [switch1 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:generalLabel];
        [switch1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = [UIColor whiteColor];
        [backView addSubview:line1];
        [line1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:generalLabel withOffset:12.0f];
        [line1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [line1 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [line1 autoSetDimension:ALDimensionHeight toSize:0.5f];
        
        UILabel *insomniaLabel = [[UILabel alloc] init];
        insomniaLabel.backgroundColor = [UIColor clearColor];
        insomniaLabel.textColor = [UIColor whiteColor];
        insomniaLabel.font = [UIFont systemFontOfSize:16.0f];
        insomniaLabel.text = NSLocalizedString(@"Insomnia", nil);
        [backView addSubview:insomniaLabel];
        [insomniaLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line1 withOffset:12.0f];
        [insomniaLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        
        UISwitch *switch2 = [[UISwitch alloc] init];
        [backView addSubview:switch2];
        [switch2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:insomniaLabel];
        [switch2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = [UIColor whiteColor];
        [backView addSubview:line2];
        [line2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:insomniaLabel withOffset:12.0f];
        [line2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [line2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [line2 autoSetDimension:ALDimensionHeight toSize:0.5f];
        
        UILabel *overweightLabel = [[UILabel alloc] init];
        overweightLabel.backgroundColor = [UIColor clearColor];
        overweightLabel.textColor = [UIColor whiteColor];
        overweightLabel.font = [UIFont systemFontOfSize:16.0f];
        overweightLabel.text = NSLocalizedString(@"Overweight", nil);
        [backView addSubview:overweightLabel];
        [overweightLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line2 withOffset:12.0f];
        [overweightLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        
        UISwitch *switch3 = [[UISwitch alloc] init];
        [backView addSubview:switch3];
        [switch3 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:overweightLabel];
        [switch3 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        
        UIView *line3 = [[UIView alloc] init];
        line3.backgroundColor = [UIColor whiteColor];
        [backView addSubview:line3];
        [line3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:overweightLabel withOffset:12.0f];
        [line3 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [line3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [line3 autoSetDimension:ALDimensionHeight toSize:0.5f];
        
        UILabel *snoringLabel = [[UILabel alloc] init];
        snoringLabel.backgroundColor = [UIColor clearColor];
        snoringLabel.textColor = [UIColor whiteColor];
        snoringLabel.font = [UIFont systemFontOfSize:16.0f];
        snoringLabel.text = NSLocalizedString(@"Snoring", nil);
        [backView addSubview:snoringLabel];
        [snoringLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line3 withOffset:12.0f];
        [snoringLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        
        UISwitch *switch4 = [[UISwitch alloc] init];
        [backView addSubview:switch4];
        [switch4 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:snoringLabel];
        [switch4 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        
        UIView *line4 = [[UIView alloc] init];
        line4.backgroundColor = [UIColor whiteColor];
        [backView addSubview:line4];
        [line4 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:snoringLabel withOffset:12.0f];
        [line4 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [line4 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [line4 autoSetDimension:ALDimensionHeight toSize:0.5f];
        
        UILabel *sportsLabel = [[UILabel alloc] init];
        sportsLabel.backgroundColor = [UIColor clearColor];
        sportsLabel.textColor = [UIColor whiteColor];
        sportsLabel.font = [UIFont systemFontOfSize:16.0f];
        sportsLabel.text = NSLocalizedString(@"Sports and exercise", nil);
        [backView addSubview:sportsLabel];
        [sportsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line4 withOffset:12.0f];
        [sportsLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        
        UISwitch *switch5 = [[UISwitch alloc] init];
        [backView addSubview:switch5];
        [switch5 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:sportsLabel];
        [switch5 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        
        UIView *line5 = [[UIView alloc] init];
        line5.backgroundColor = [UIColor whiteColor];
        [backView addSubview:line5];
        [line5 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:sportsLabel withOffset:12.0f];
        [line5 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [line5 autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [line5 autoSetDimension:ALDimensionHeight toSize:0.5f];
        
        UILabel *stressLabel = [[UILabel alloc] init];
        stressLabel.backgroundColor = [UIColor clearColor];
        stressLabel.textColor = [UIColor whiteColor];
        stressLabel.font = [UIFont systemFontOfSize:16.0f];
        stressLabel.text = NSLocalizedString(@"Stress", nil);
        [backView addSubview:stressLabel];
        [stressLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line5 withOffset:12.0f];
        [stressLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        
        UISwitch *switch6 = [[UISwitch alloc] init];
        [backView addSubview:switch6];
        [switch6 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:stressLabel];
        [switch6 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        
        [backView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:stressLabel withOffset:13.0f];
        
        desLabel = [[UILabel alloc] init];
        desLabel.numberOfLines = 0;
        desLabel.backgroundColor = [UIColor clearColor];
        desLabel.textColor = RGB(90,107,109);
        desLabel.font = [UIFont systemFontOfSize:12.0f];
        desLabel.text = NSLocalizedString(@"Select the topic for which you want to get sleep information and tips", nil);
        [self.contentView addSubview:desLabel];
        [desLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:backView withOffset:3.0f];
        [desLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12.0f];
        [desLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:12.0f];
        
    }
    
    return self;
}

- (void)configCell {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGFloat)cellHeight {
    return desLabel.bottom + 25.0f;
}

@end
