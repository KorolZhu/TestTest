//
//  WBSingleton.h
//  WristBand
//
//  Created by zhuzhi on 14/11/11.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#ifndef WristBand_WBSingleton_h
#define WristBand_WBSingleton_h

#define WB_AS_SINGLETON( __class , __method) \
+ (__class *)__method;


#define WB_DEF_SINGLETON( __class , __method ) \
+ (__class *)__method {\
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

#endif
