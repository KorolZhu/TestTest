//
//  WBDataItem.h
//  WristBand
//
//  Created by zhuzhi on 14/11/27.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBDataItem : NSObject

@property (nonatomic)UInt16 value;
@property (nonatomic)NSTimeInterval timeStamp;

- (instancetype)initWithString:(NSString *)string;

@end
