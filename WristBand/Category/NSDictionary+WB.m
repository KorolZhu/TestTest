//
//  NSDictionary+WB.m
//  WristBand
//
//  Created by zhuzhi on 14/11/29.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "NSDictionary+WB.h"

@implementation NSDictionary (WB)

- (NSString *)stringForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string;
        }
        
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.stringValue;
        }
    }
    
    return nil;
}


- (BOOL)boolForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.boolValue;
        }
        
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.boolValue;
        }
    }
    
    return NO;
}

- (int)intForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.intValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.intValue;
        }
    }
    
    return -1;
}

- (uint)uintForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.unsignedLongValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.intValue;
        }
    }
    
    return 0;
}

- (double)doubleForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.doubleValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.doubleValue;
        }
    }
    
    return -1.0;
}

- (float)floatForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.floatValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.floatValue;
        }
    }
    
    return -1.0f;
}

- (long long)longLongForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.longLongValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.longLongValue;
        }
    }
    
    return -1.0;
}

- (u_int64_t)ulongLongForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            NSNumber *number = object;
            return number.unsignedLongLongValue;
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            NSString *string = object;
            return string.longLongValue;
        }
    }
    
    return 0;
}

- (NSArray *)arrayForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && [object isKindOfClass:[NSArray class]]) {
        NSArray *array = object;
        return array;
    }
    
    return nil;
}

- (NSDictionary *)dictionaryForKey:(id)key {
    id object = [self objectForKey:key];
    
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = object;
        return dictionary;
    }
    
    return nil;
}

@end
