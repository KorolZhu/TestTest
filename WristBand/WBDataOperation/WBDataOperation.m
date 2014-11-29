//
//  WBDataOperation.m
//  WristBand
//
//  Created by zhuzhi on 14/11/27.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBDataOperation.h"
#import "WBDataItem.h"
#import "WBSleepStage.h"
#import "WBSQLBuffer.h"
#import "WBDatabaseService.h"
#import "WBSleepInfo.h"
#import "WBSleepPoint.h"
#import "WBPath.h"

@interface WBDataOperation ()
{
    NSMutableString *mutableString;
	NSInteger currentDateymd;
}

@end

@implementation WBDataOperation

WB_DEF_SINGLETON(WBDataOperation, shareInstance);

- (instancetype)init {
    self = [super init];
    if (self) {
        mutableString = [[NSMutableString alloc] init];
    }
    
    return self;
}

- (void)startSleep {
    // 判断当前是否大于12点，大于则当前睡眠时间计入下一天
    NSInteger hour = [NSDate currentHour];
    if (hour > 12) {
        NSDate *nextDay = [[NSDate date] dateByAddingTimeInterval:12 * 3600];
        NSString *date = [nextDay stringWithFormat:@"yyyyMMdd"];
        currentDateymd = [date integerValue];
    } else {
        NSString *date = [[NSDate date] stringWithFormat:@"yyyyMMdd"];
        currentDateymd = [date integerValue];
    }
    
	WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] init];
	sqlbuffer.SELECT(@"*").FROM(@"SLEEP").WHERE([NSString stringWithFormat:@"%@=%ld", @"DATEYMD", (long)currentDateymd]);
	WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlbuffer];
    [[WBDatabaseService defaultService] readWithTransaction:transaction completionBlock:^{}];
    if (transaction.resultSet.resultArray.count == 0) {
        WBSQLBuffer *insertSqlbuffer = [[WBSQLBuffer alloc] init];
        insertSqlbuffer.INSERT(@"SLEEP").SET(@"DATEYMD",@(currentDateymd)).SET(@"STARTTIME",@([[NSDate date] timeIntervalSince1970]));
        WBDatabaseTransaction *insertTransaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:insertSqlbuffer];
        [[WBDatabaseService defaultService] writeWithTransaction:insertTransaction completionBlock:^{}];
    }
}

- (void)stopSleep {
    if (mutableString.length > 0) {
        NSString *documentPath = [WBPath documentPath];
        NSString *dataPath = [documentPath stringByAppendingFormat:@"/%@.dat", @(currentDateymd).stringValue];
        NSData *dataToAppend = [mutableString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
            [dataToAppend writeToFile:dataPath atomically:YES];
        } else {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:dataPath];
            [fileHandle seekToEndOfFile];
            
            [fileHandle writeData:dataToAppend];
            [fileHandle closeFile];
        }
        
        [mutableString deleteCharactersInRange:NSMakeRange(0, mutableString.length)];
    }
    
    WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] init];
    sqlbuffer.UPDATE(@"SLEEP").SET(@"ENDTIME", @([[NSDate date] timeIntervalSince1970])).WHERE([NSString stringWithFormat:@"%@=%ld", @"DATEYMD", (long)currentDateymd]);
    WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlbuffer];
    [[WBDatabaseService defaultService] writeWithTransaction:transaction completionBlock:^{}];
    
    [self analysing];
}

- (void)bleDidReceiveData:(UInt16)value {
    NSString *string = [NSString stringWithFormat:@"%4d,%.3f;", value, [[NSDate date] timeIntervalSince1970]];
    [mutableString appendString:string];
    
    if (mutableString.length > 1000) {
        NSString *documentPath = [WBPath documentPath];
        NSString *dataPath = [documentPath stringByAppendingFormat:@"/%@.dat", @(currentDateymd).stringValue];
        NSString *stringToAppend = [mutableString substringToIndex:1000];
        NSData *dataToAppend = [stringToAppend dataUsingEncoding:NSUTF8StringEncoding];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
            [dataToAppend writeToFile:dataPath atomically:YES];
        } else {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:dataPath];
            [fileHandle seekToEndOfFile];
            
            [fileHandle writeData:dataToAppend];
            [fileHandle closeFile];
        }
        
        [mutableString deleteCharactersInRange:NSMakeRange(0, 1000)];
    }
}

- (void)analysing {
    NSString *documentPath = [WBPath documentPath];
    NSString *dataPath = [documentPath stringByAppendingFormat:@"/%@.dat", @(currentDateymd).stringValue];
    NSString *dataString = [[NSString alloc] initWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:NULL];
    if (dataString.length < 2 * 60 * 5) {
        return;
    }
    
    NSArray *dataArray = [dataString componentsSeparatedByString:@";"];
    NSMutableArray *sleepStages = [NSMutableArray array];
    
    NSInteger startIndex = 0;
    WBDataItem *firstItem = [[WBDataItem alloc] initWithString:dataArray.firstObject];
    for (NSInteger i = 0; i < dataArray.count; i++) {
        NSString *string = [dataArray objectAtIndex:i];
        WBDataItem *item = [[WBDataItem alloc] initWithString:string];
        
        // to bed 时间
        if (item.timeStamp - firstItem.timeStamp > 5 * 60) {
            // 更新to bed的时间
            WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] init];
            sqlbuffer.UPDATE(@"SLEEP").SET(@"TOBEDTIME", @(item.timeStamp)).WHERE([NSString stringWithFormat:@"%@=%ld", @"DATEYMD", (long)currentDateymd]);
            WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlbuffer];
            [[WBDatabaseService defaultService] writeWithTransaction:transaction completionBlock:^{}];
            
            // 添加空白区域
            WBDataItem *firstItem = [[WBDataItem alloc] initWithString:dataArray.firstObject];
            WBSleepStage *sleepStage = [[WBSleepStage alloc] init];
            sleepStage.type = WBSleepStageTypeAway;
            sleepStage.startTimeStamp = firstItem.timeStamp;
            sleepStage.endTimeStamp = item.timeStamp;
            [sleepStages addObject:sleepStage];
            
            startIndex = i;
            
            break;
        }
    }
    
    firstItem = nil;
    for (NSInteger i = startIndex; i < dataArray.count; i++) {
        NSString *string = [dataArray objectAtIndex:i];
        WBDataItem *item = [[WBDataItem alloc] initWithString:string];
        if (!firstItem) {
            firstItem = item;
        }
        
        if (item.timeStamp - firstItem.timeStamp > 5 * 60) {
            // 添加灰色区域
            WBSleepStage *sleepStage = [[WBSleepStage alloc] init];
            sleepStage.type = WBSleepStageTypeAwake;
            sleepStage.startTimeStamp = firstItem.timeStamp;
            sleepStage.endTimeStamp = item.timeStamp;
            [sleepStages addObject:sleepStage];
            
            startIndex = i;
            
            break;
            
        }
    }
    
    firstItem = nil;
    for (NSInteger i = startIndex; i < dataArray.count; i++) {
        NSString *string = [dataArray objectAtIndex:i];
        WBDataItem *item = [[WBDataItem alloc] initWithString:string];
        if (!firstItem) {
            firstItem = item;
        }
        
        if (item.timeStamp - firstItem.timeStamp > 5 * 60) {
            // 添加蓝色区域
            WBSleepStage *sleepStage = [[WBSleepStage alloc] init];
            sleepStage.type = (arc4random() % 2 == 1) ? WBSleepStageTypeFallasleepDeep : WBSleepStageTypeFallasleepLight;
            sleepStage.startTimeStamp = firstItem.timeStamp;
            sleepStage.endTimeStamp = item.timeStamp;
            [sleepStages addObject:sleepStage];
            
            firstItem = nil;
        }
    }
    
    WBMutableSQLBuffer *mutableSqlBuffer = [[WBMutableSQLBuffer alloc] init];
    for (WBSleepStage *sleepStage in sleepStages) {
        WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] init];
        sqlbuffer.INSERT(@"SLEEPSTAGE")
        .SET(@"DATEYMD",@(currentDateymd))
        .SET(@"ENDTIME",@(sleepStage.endTimeStamp))
        .SET(@"STARTTIME",@(sleepStage.startTimeStamp))
        .SET(@"STAGE",@(sleepStage.type));
        [mutableSqlBuffer addBuffer:sqlbuffer];
    }
    
    WBDatabaseTransaction *insertTransaction = [[WBDatabaseTransaction alloc] initWithMutalbeSQLBuffer:mutableSqlBuffer];
    [[WBDatabaseService defaultService] writeWithTransaction:insertTransaction completionBlock:^{
        if (insertTransaction.resultSet.resultCode == HTDatabaseResultSucceed) {
            NSLog(@"Analysing succeed");
        }
    }];
    
    
//    // 得分计算
//    WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] init];
//    sqlbuffer.INSERT(@"SLEEPPROPERTY")
//    .SET(@"DATEYMD",@(currentDateymd))
//    .SET(@"AMOUNTOFSLEEP",@(100))
//    .SET(@"SLEEPVSAWAKE",@(10))
//    .SET(@"SLEEPLATENCY",@(10))
//    .SET(@"GOTUP",@(10))
//    .SET(@"WAKINGEVENTS",@(10))
//    .SET(@"SNORING",@(10))
//    .SET(@"TOTAL",@(10))
//    .SET(@"BPM",@(10))
//    .SET(@"BREATHSPM",@(10));
//    WBDatabaseTransaction *insertTransaction = [[WBDatabaseTransaction alloc] initWithMutalbeSQLBuffer:mutableSqlBuffer];
//    [[WBDatabaseService defaultService] writeWithTransaction:insertTransaction completionBlock:^{
//        if (insertTransaction.resultSet.resultCode == HTDatabaseResultSucceed) {
//            NSLog(@"Analysing succeed");
//        }
//    }];

    
//    NSInteger startIndex = 0;
//    for (NSInteger i = 0; i < dataArray.count; i++) {
//        NSString *string = [dataArray objectAtIndex:i];
//        WBDataItem *item = [[WBDataItem alloc] initWithString:string];
//        
//        if (item.value > 2000) {
//            // 更新to bed的时间
//            WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] init];
//            sqlbuffer.UPDATE(@"SLEEP").SET(@"TOBEDTIME", @(item.timeStamp)).WHERE([NSString stringWithFormat:@"%@=%ld", @"DATEYMD", (long)currentDateymd]);
//            WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlbuffer];
//            [[WBDatabaseService defaultService] writeWithTransaction:transaction completionBlock:^{}];
//            
//            // 添加空白区域
//            WBDataItem *firstItem = [[WBDataItem alloc] initWithString:dataArray.firstObject];
//            WBSleepStage *sleepStage = [[WBSleepStage alloc] init];
//            sleepStage.type = WBSleepStageTypeAway;
//            sleepStage.startTimeStamp = firstItem.timeStamp;
//            sleepStage.endTimeStamp = item.timeStamp;
//            [sleepStages addObject:sleepStage];
//            
//            startIndex = i;
//            break;
//        } else if (i == dataArray.count - 1) {
//            // 添加空白区域
//            WBDataItem *firstItem = [[WBDataItem alloc] initWithString:dataArray.firstObject];
//            WBSleepStage *sleepStage = [[WBSleepStage alloc] init];
//            sleepStage.type = WBSleepStageTypeAway;
//            sleepStage.startTimeStamp = firstItem.timeStamp;
//            sleepStage.endTimeStamp = item.timeStamp;
//            [sleepStages addObject:sleepStage];
//            
//            startIndex = i;
//        }
//    }
//    
//    for (NSInteger i = startIndex; i < dataArray.count; i++) {
//        // 找出第一次入睡的时间，电压值在<850,1150>之间变化
//        NSString *string = [dataArray objectAtIndex:i];
//        WBDataItem *item = [[WBDataItem alloc] initWithString:string];
//        
//        
//
//    }
    
}

- (NSArray *)querySleepData {
	NSMutableArray *mutableArr = [NSMutableArray array];
	NSDateFormatter *dateFormatter = nil;
	
	NSString *sql = @"SELECT * FROM SLEEP";
	WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] initWithSQL:sql];
	WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlbuffer];
	[[WBDatabaseService defaultService] readWithTransaction:transaction completionBlock:^{}];
	for (NSDictionary *dictionary in transaction.resultSet.resultArray) {
		NSInteger tempDateymd = [[dictionary objectForKey:@"DATEYMD"] integerValue];
		WBSQLBuffer *stageSqlbuffer = [[WBSQLBuffer alloc] init];
		stageSqlbuffer.SELECT(@"*").FROM(@"SLEEPSTAGE").WHERE([NSString stringWithFormat:@"%@=%ld",@"DATEYMD", (long)(long)tempDateymd]).ORDERBY(@"STARTTIME",ASC);
		WBDatabaseTransaction *stageTransaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:stageSqlbuffer];
		[[WBDatabaseService defaultService] readWithTransaction:stageTransaction completionBlock:^{}];
		
		WBSleepInfo *sleepInfo = [[WBSleepInfo alloc] init];
		
		if (!dateFormatter) {
			dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyyMMdd"];
		}
		
		sleepInfo.time = [[dateFormatter dateFromString:[[dictionary objectForKey:@"DATEYMD"] stringValue]] timeIntervalSince1970];

		NSMutableArray *array = [NSMutableArray array];
		
		for (NSDictionary *stageDic in stageTransaction.resultSet.resultArray) {
			NSMutableArray *pointAray = [NSMutableArray array];
			
			double startValue = [[stageDic objectForKey:@"STARTTIME"] doubleValue];
			double endValue = [[stageDic objectForKey:@"ENDTIME"] doubleValue];
			int stage = [[stageDic objectForKey:@"STAGE"] intValue];
			
			WBSleepPoint *sleepPoint = [[WBSleepPoint alloc] init];
			sleepPoint.time = startValue;
			sleepPoint.state = stage;
			if (stage == WBSleepStageTypeAway || stage == WBSleepStageTypeAwake) {
				sleepPoint.sleepValue = 20.0f;
			} else if (stage == WBSleepStageTypeFallasleepDeep) {
				sleepPoint.sleepValue = 30.0f;
			} else if (stage == WBSleepStageTypeFallasleepLight) {
				sleepPoint.sleepValue = arc4random() % 10 + 20;
			}
			
			WBSleepPoint *sleepPoint2 = [[WBSleepPoint alloc] init];
			sleepPoint2.time = endValue;
			sleepPoint2.state = stage;
			if (stage == WBSleepStageTypeAway || stage == WBSleepStageTypeAwake) {
				sleepPoint2.sleepValue = 20.0f;
			} else if (stage == WBSleepStageTypeFallasleepDeep) {
				sleepPoint2.sleepValue = 30.0f;
			} else if (stage == WBSleepStageTypeFallasleepLight) {
				sleepPoint2.sleepValue = arc4random() % 10 + 20;
			}
			
			[pointAray addObject:sleepPoint];
			[pointAray addObject:sleepPoint2];
			
			[array addObject:pointAray];
		}
		
        if (array.count > 0) {
            sleepInfo.sleepPoints = [NSArray arrayWithArray:array];
        }
		[sleepInfo setup];
		
		[mutableArr addObject:sleepInfo];
	}

	
	return mutableArr;
}

@end
