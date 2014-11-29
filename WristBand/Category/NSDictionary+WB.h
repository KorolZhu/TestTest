//
//  NSDictionary+WB.h
//  WristBand
//
//  Created by zhuzhi on 14/11/29.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WB)

- (NSString *)stringForKey:(id)key;
- (BOOL)boolForKey:(id)key;
- (int)intForKey:(id)key;
- (uint)uintForKey:(id)key;
- (double)doubleForKey:(id)key;
- (float)floatForKey:(id)key;
- (long long)longLongForKey:(id)key;
- (u_int64_t)ulongLongForKey:(id)key;
- (NSArray *)arrayForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;

@end
