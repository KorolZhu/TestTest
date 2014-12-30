//
//  WBDataOperation.m
//  WristBand
//
//  Created by zhuzhi on 14/11/27.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBDataOperation.h"
#import "WBDataItem.h"
#import "WBDataItem2.h"
#import "WBSleepStage.h"
#import "WBSQLBuffer.h"
#import "WBDatabaseService.h"
#import "WBSleepInfo.h"
#import "WBSleepPoint.h"
#import "WBPath.h"

NSString * const WBDataAnalysingFinishedNotification = @"WBDataAnalysingFinishedNotification";

#define WBAnalyseTimeInterval 20 * 60
#define WBBLEDataReadTimesPerSecond 5

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
	
//	currentDateymd = 20141130;
	
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
	
    [self analysing];
}

- (void)bleDidReceiveData:(unsigned char *)data length:(int)length {
    if (length < 5) {
        return;
    }
    
    UInt8 temp = data[1];
    UInt8 sleepState = temp >> 4;
    UInt8 snoring = temp & 15;
    UInt8 breath = data[2];
    UInt8 heart = data[3];
    UInt8 turnover = data[4];
    
    NSString *string = [NSString stringWithFormat:@"%d,%d,%d,%d,%d,%.3f;", sleepState, snoring, breath, heart, turnover, [[NSDate date] timeIntervalSince1970]];
    [mutableString appendString:string];
    
    NSLog(@"%@", string);
    
    if (mutableString.length > 1000) {
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
}

- (void)analysing {
	NSString *documentPath = [WBPath documentPath];
	NSString *dataPath = [documentPath stringByAppendingFormat:@"/%@.dat", @(currentDateymd).stringValue];
	//    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"20141201" ofType:@"dat"];
	NSString *dataString = [[NSString alloc] initWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:NULL];
	if (dataString.length > 1) {
		dataString = [dataString stringByReplacingCharactersInRange:NSMakeRange(dataString.length - 1, 1) withString:@""];
	}
	
	NSArray *dataArray = [dataString componentsSeparatedByString:@";"];
	
	NSMutableArray *sleepStages = [NSMutableArray array];
	double totalSleepTime = 0.0f;
	double startFallasleepTime = 0.0f;
	double tobedTime = 0.0f;
	double totalAwakeTime = 0.0f;
	int wakingEvents = 0;
	
	WBDataItem2 *startItem = nil;
	BOOL foundTobedTime = NO;
	
	NSInteger awayCount = 0;
	NSInteger awakeCount = 0;
	NSInteger lightCount = 0;
	NSInteger deepCount = 0;

	for (NSString *string in dataArray) {
		WBDataItem2 *item = [[WBDataItem2 alloc] initWithString:string];
		
		if (!startItem) {
			startItem = item;
		}
		
		if (!foundTobedTime && item.sleepState == SleepStateStartSleep) {
			foundTobedTime = YES;
			
			tobedTime = item.timeStamp;
			
			WBSleepStage *stage = [[WBSleepStage alloc] init];
			stage.dateYMD = currentDateymd;
			stage.startTimeStamp = startItem.timeStamp;
			stage.endTimeStamp = item.timeStamp;
			stage.type = WBSleepStageTypeAway;
			stage.deepValue = 15;
			[sleepStages addObject:stage];
			
			startItem = nil;
			
			continue;
		}
		
		if (!foundTobedTime) {
			continue;
		}
		
		if (item.sleepState == SleepStateDeepSleep) {
			totalSleepTime += 30;
			
			if (startFallasleepTime == 0.0f) {
				startFallasleepTime = item.timeStamp;
			}
			
			deepCount++;
		}
		
		if (item.sleepState == SleepStateLightSleep) {
			totalSleepTime += 30;
			
			if (startFallasleepTime == 0.0f) {
				startFallasleepTime = item.timeStamp;
			}
			
			lightCount++;
		}
		
		if (item.sleepState == SleepStateAwake) {
			totalAwakeTime += 30;
			wakingEvents++;
			
			awakeCount++;
		}
		
		if (item.sleepState == SleepStateNone) {
			totalAwakeTime += 30;
			wakingEvents++;
			
			awayCount++;
		}
		
		if (item.timeStamp - startItem.timeStamp >= 20 * 60 || string == dataArray.lastObject) {
			NSInteger max = 0;
			if (awayCount > max) {
				max = awayCount;
			}
			
			if (awakeCount > max) {
				max = awakeCount;
			}
			
			if (lightCount > max) {
				max = lightCount;
			}
			
			if (deepCount > max) {
				max = deepCount;
			}
			
			if (max == awayCount) {
				WBSleepStage *stage = [[WBSleepStage alloc] init];
				stage.dateYMD = currentDateymd;
				stage.startTimeStamp = startItem.timeStamp;
				stage.endTimeStamp = item.timeStamp;
				stage.type = WBSleepStageTypeAway;
				stage.deepValue = 15;
				[sleepStages addObject:stage];
			} else if (max == awakeCount) {
				WBSleepStage *stage = [[WBSleepStage alloc] init];
				stage.dateYMD = currentDateymd;
				stage.startTimeStamp = startItem.timeStamp;
				stage.endTimeStamp = item.timeStamp;
				stage.type = WBSleepStageTypeAwake;
				stage.deepValue = 15;
				[sleepStages addObject:stage];
			} else if (max == lightCount) {
				WBSleepStage *stage = [[WBSleepStage alloc] init];
				stage.dateYMD = currentDateymd;
				stage.startTimeStamp = startItem.timeStamp;
				stage.endTimeStamp = item.timeStamp;
				stage.type = WBSleepStageTypeFallasleepLight;
				stage.deepValue = arc4random() % 15 + 12;
				[sleepStages addObject:stage];
			} else {
				WBSleepStage *stage = [[WBSleepStage alloc] init];
				stage.dateYMD = currentDateymd;
				stage.startTimeStamp = startItem.timeStamp;
				stage.endTimeStamp = item.timeStamp;
				stage.type = WBSleepStageTypeFallasleepDeep;
				stage.deepValue = arc4random() % 3 + 27;
				[sleepStages addObject:stage];
			}
			
			startItem = nil;
			awayCount = 0;
			awakeCount = 0;
			lightCount = 0;
			deepCount = 0;
		}
	}
	
	if (!foundTobedTime && dataArray.count >= 2) {
		WBDataItem2 *firstItem = [[WBDataItem2 alloc] initWithString:dataArray.firstObject];
		WBDataItem2 *endItem = [[WBDataItem2 alloc] initWithString:dataArray.lastObject];

		WBSleepStage *stage = [[WBSleepStage alloc] init];
		stage.dateYMD = currentDateymd;
		stage.startTimeStamp = firstItem.timeStamp;
		stage.endTimeStamp = endItem.timeStamp;
		stage.type = WBSleepStageTypeAway;
        stage.deepValue = 15;
		[sleepStages addObject:stage];
	}
	
	// 保存睡眠状态
	WBMutableSQLBuffer *mutableSqlBuffer = [[WBMutableSQLBuffer alloc] init];
	
	WBSQLBuffer *deleteSqlBuffer = [[WBSQLBuffer alloc] init];
	deleteSqlBuffer.DELELTE(@"SLEEPSTAGE").WHERE([NSString stringWithFormat:@"%@=%@",@"DATEYMD", @(currentDateymd).stringValue]);
	[mutableSqlBuffer addBuffer:deleteSqlBuffer];
	
	for (WBSleepStage *sleepStage in sleepStages) {
		WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] init];
		sqlbuffer.INSERT(@"SLEEPSTAGE")
		.SET(@"DATEYMD",@(sleepStage.dateYMD))
		.SET(@"ENDTIME",@(sleepStage.endTimeStamp))
		.SET(@"STARTTIME",@(sleepStage.startTimeStamp))
		.SET(@"STAGE",@(sleepStage.type))
		.SET(@"DEEPVALUE",@(sleepStage.deepValue));
		[mutableSqlBuffer addBuffer:sqlbuffer];
	}
	WBDatabaseTransaction *insertTransaction = [[WBDatabaseTransaction alloc] initWithMutalbeSQLBuffer:mutableSqlBuffer];
	[[WBDatabaseService defaultService] writeWithTransaction:insertTransaction completionBlock:^{
		if (insertTransaction.resultSet.resultCode == HTDatabaseResultSucceed) {
			NSLog(@"Analysing succeed1");
		}
	}];
	
	// 更新睡眠相关时间
	NSTimeInterval endTime = 0.0f;
	NSString *string = dataArray.lastObject;
	WBDataItem2 *endItem = [[WBDataItem2 alloc] initWithString:string];
	endTime = endItem.timeStamp;
	
	WBSQLBuffer *updateFallasleepSqlbuffer = [[WBSQLBuffer alloc] init];
	updateFallasleepSqlbuffer.UPDATE(@"SLEEP")
	.SET(@"FALLASLEEPTIME", @(startFallasleepTime))
	.SET(@"TOBEDTIME", @(tobedTime))
	.SET(@"ENDTIME", @(endTime))
	.WHERE([NSString stringWithFormat:@"%@=%ld", @"DATEYMD", (long)currentDateymd]);
	WBDatabaseTransaction *updateFallasleepTransaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:updateFallasleepSqlbuffer];
	[[WBDatabaseService defaultService] writeWithTransaction:updateFallasleepTransaction completionBlock:^{}];
	
	// 得分计算
	int sleepLatency = 0;
	int amountOfSleep = 0;
	int gotupFromBed = 0;
	int wakingEventsPoint = 0;
	int snoring = 0;
	int sleepVSAwaketime = 0;
	int totalPoint = 0;
	
	WBDataItem2 *firstItem = [[WBDataItem2 alloc] initWithString:dataArray.firstObject];
	if (startFallasleepTime > 0.0f && startFallasleepTime - firstItem.timeStamp < 5 * 60) {
		sleepLatency = 15;
	} else if (startFallasleepTime > 0.0f && startFallasleepTime - firstItem.timeStamp < 10 * 60) {
		sleepLatency = 10;
	}
	
	float totalSleepHour = totalSleepTime / 3600.0f;
	amountOfSleep = totalSleepHour * 10.0f;
	wakingEventsPoint = (wakingEvents > 2) ? -5 : 0;
	sleepVSAwaketime = totalSleepTime > totalAwakeTime ? 10 : -10;
	
	totalPoint = amountOfSleep + gotupFromBed + wakingEventsPoint + snoring + sleepLatency + sleepVSAwaketime;
	
	// 保存得分
	WBSQLBuffer *pointSqlbuffer = [[WBSQLBuffer alloc] init];
	pointSqlbuffer.REPLACE(@"SLEEPPROPERTY")
	.SET(@"DATEYMD",@(currentDateymd))
	.SET(@"AMOUNTOFSLEEP",@(amountOfSleep))
	.SET(@"SLEEPVSAWAKE",@(sleepVSAwaketime))
	.SET(@"SLEEPLATENCY",@(sleepLatency))
	.SET(@"GOTUP",@(gotupFromBed))
	.SET(@"WAKINGEVENTS",@(wakingEventsPoint))
	.SET(@"SNORING",@(snoring))
	.SET(@"TOTAL",@(totalPoint))
	.SET(@"BPM",@(45 + arc4random() % 20))
	.SET(@"BREATHSPM",@(15 + arc4random() % 5))
	.SET(@"TOTALSLEEPTIME", @(totalSleepTime))
	.WHERE([NSString stringWithFormat:@"%@=%ld", @"DATEYMD", (long)currentDateymd]);
	WBDatabaseTransaction *pointUpdateTransaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:pointSqlbuffer];
	[[WBDatabaseService defaultService] writeWithTransaction:pointUpdateTransaction completionBlock:^{
		if (insertTransaction.resultSet.resultCode == HTDatabaseResultSucceed) {
			NSLog(@"Analysing succeed2");
		}
	}];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:WBDataAnalysingFinishedNotification object:nil];
}
	
//- (void)analysing {
//    NSString *documentPath = [WBPath documentPath];
//    NSString *dataPath = [documentPath stringByAppendingFormat:@"/%@.dat", @(currentDateymd).stringValue];
////    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"20141201" ofType:@"dat"];
//    NSString *dataString = [[NSString alloc] initWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:NULL];
//	if (dataString.length > 1) {
//		dataString = [dataString stringByReplacingCharactersInRange:NSMakeRange(dataString.length - 1, 1) withString:@""];
//	}
//	
//    NSArray *dataArray = [dataString componentsSeparatedByString:@";"];
//    
//    if (dataArray.count < 2 * 60 * 5) {
//        return;
//    }
//    
//    NSMutableArray *intervalArray = [NSMutableArray array];
//    
//    // 算出每两个值之间的差值
//    for (int i = 0; i < dataArray.count; i++) {
//        NSString *string = [dataArray objectAtIndex:i];
//        WBDataItem *item = [[WBDataItem alloc] initWithString:string];
//        
//        if (i + 1 < dataArray.count) {
//            NSString *string1 = [dataArray objectAtIndex:i + 1];
//            WBDataItem *item1 = [[WBDataItem alloc] initWithString:string1];
//            
//            [intervalArray addObject:@(ABS(item1.value - item.value))];
//        }
//    }
//    
//    NSMutableArray *sleepStages = [NSMutableArray array];
//    double totalSleepTime = 0.0f;
//    double startFallasleepTime = 0.0f;
//	double tobedTime = 0.0f;
//    double totalAwakeTime = 0.0f;
//    int wakingEvents = 0;
//    
//    // 根据值的波动幅度，每20十分钟取一个点，判断这20分钟之内属于哪个状态
//    // 离开：平均值少于<25
//    // 醒着：平均值大于>350
//    // 深睡：电压值在<850,1150>之间变化 | 平均值在<25,150>
//    // 浅睡：平均值在[150，350]之间
//	WBDataItem *startItem = nil;;
//	NSInteger startIndex = 0;
//	NSInteger total = 0;
//	WBSleepStage *lastSleepStage = nil;
//	
//	WBDataItem *lastItem = 0;
//	
//    for (NSInteger i = 0; i < intervalArray.count; i++) {
//        NSString *string = [dataArray objectAtIndex:i];
//        WBDataItem *item = [[WBDataItem alloc] initWithString:string];
//		
//		if (!startItem) {
//			startItem = item;
//			startIndex = i;
//			total = 0;
//		}
//		
//		BOOL blank = NO;
//		if (item.timeStamp - lastItem.timeStamp > 2* 60 && lastItem) {
//			// 需要处理中间有空白的部分,空白超过2分钟
//			WBSleepStage *stage = [[WBSleepStage alloc] init];
//			stage.dateYMD = currentDateymd;
//			stage.startTimeStamp = lastItem.timeStamp;
//			stage.endTimeStamp = item.timeStamp;
//			stage.type = WBSleepStageTypeAway;
//			stage.deepValue = 15;
//			[sleepStages addObject:stage];
//			
//			blank = YES;
//		}
//		
//		if (!blank) {
//			total += [[intervalArray objectAtIndex:i] integerValue];
//		}
//
//		if (item.timeStamp - startItem.timeStamp > 20 * 60 || i == intervalArray.count - 1 || blank) {
//			WBSleepStage *stage = [[WBSleepStage alloc] init];
//			stage.dateYMD = currentDateymd;
//			stage.startTimeStamp = startItem.timeStamp;
//			stage.endTimeStamp =  blank ? lastItem.timeStamp : item.timeStamp;
//			
//			float average = total / ((blank ? i - 1 : i) - startIndex + 1);
//			if (average < 25) {
//				stage.type = WBSleepStageTypeAway;
//				stage.deepValue = 15;
//			} else if (average < 150) {
//				if (startFallasleepTime == 0.0f) {
//					startFallasleepTime = startItem.timeStamp;
//				}
//				totalSleepTime += WBAnalyseTimeInterval;
//				stage.type = WBSleepStageTypeFallasleepDeep;
//				stage.deepValue = arc4random() % 3 + 27;
//			} else if (average < 350) {
//				if (startFallasleepTime == 0.0f) {
//					startFallasleepTime = startItem.timeStamp;
//				}
//				totalSleepTime += WBAnalyseTimeInterval;
//				stage.type = WBSleepStageTypeFallasleepLight;
//				stage.deepValue = arc4random() % 15 + 15;
//			} else {
//				stage.type = WBSleepStageTypeAwake;
//				stage.deepValue = 15;
//				totalAwakeTime += WBAnalyseTimeInterval;
//				if (stage.type != lastSleepStage.type) {
//					wakingEvents ++;
//				}
//			}
//			
//			if (stage.type != WBSleepStageTypeAway) {
//				if (tobedTime == 0.0f) {
//					tobedTime = startItem.timeStamp;
//				}
//			}
//			
//			[sleepStages addObject:stage];
//			
//			startItem = nil;
//			lastSleepStage = stage;
//		}
//		
//		lastItem = item;
//    }
//	
//    // 保存睡眠状态
//    WBMutableSQLBuffer *mutableSqlBuffer = [[WBMutableSQLBuffer alloc] init];
//	
//	WBSQLBuffer *deleteSqlBuffer = [[WBSQLBuffer alloc] init];
//	deleteSqlBuffer.DELELTE(@"SLEEPSTAGE").WHERE([NSString stringWithFormat:@"%@=%@",@"DATEYMD", @(currentDateymd).stringValue]);
//	[mutableSqlBuffer addBuffer:deleteSqlBuffer];
//	
//    for (WBSleepStage *sleepStage in sleepStages) {
//        WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] init];
//        sqlbuffer.INSERT(@"SLEEPSTAGE")
//        .SET(@"DATEYMD",@(sleepStage.dateYMD))
//        .SET(@"ENDTIME",@(sleepStage.endTimeStamp))
//        .SET(@"STARTTIME",@(sleepStage.startTimeStamp))
//        .SET(@"STAGE",@(sleepStage.type))
//		.SET(@"DEEPVALUE",@(sleepStage.deepValue));
//        [mutableSqlBuffer addBuffer:sqlbuffer];
//    }
//    WBDatabaseTransaction *insertTransaction = [[WBDatabaseTransaction alloc] initWithMutalbeSQLBuffer:mutableSqlBuffer];
//    [[WBDatabaseService defaultService] writeWithTransaction:insertTransaction completionBlock:^{
//        if (insertTransaction.resultSet.resultCode == HTDatabaseResultSucceed) {
//            NSLog(@"Analysing succeed1");
//        }
//    }];
//	
//    // 更新睡眠相关时间
//	NSTimeInterval endTime = 0.0f;
//	NSString *string = dataArray.lastObject;
//	WBDataItem *endItem = [[WBDataItem alloc] initWithString:string];
//	endTime = endItem.timeStamp;
//
//    WBSQLBuffer *updateFallasleepSqlbuffer = [[WBSQLBuffer alloc] init];
//    updateFallasleepSqlbuffer.UPDATE(@"SLEEP")
//	.SET(@"FALLASLEEPTIME", @(startFallasleepTime))
//	.SET(@"TOBEDTIME", @(tobedTime))
//	.SET(@"ENDTIME", @(endTime))
//	.WHERE([NSString stringWithFormat:@"%@=%ld", @"DATEYMD", (long)currentDateymd]);
//    WBDatabaseTransaction *updateFallasleepTransaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:updateFallasleepSqlbuffer];
//    [[WBDatabaseService defaultService] writeWithTransaction:updateFallasleepTransaction completionBlock:^{}];
//    
//    // 得分计算
//    int sleepLatency = 0;
//    int amountOfSleep = 0;
//    int gotupFromBed = 0;
//    int wakingEventsPoint = 0;
//    int snoring = 0;
//    int sleepVSAwaketime = 0;
//    int totalPoint = 0;
//    
//    WBDataItem *firstItem = [[WBDataItem alloc] initWithString:dataArray.firstObject];
//    if (startFallasleepTime > 0.0f && startFallasleepTime - firstItem.timeStamp < 5 * 60) {
//        sleepLatency = 5;
//    } else if (startFallasleepTime > 0.0f && startFallasleepTime - firstItem.timeStamp < 10 * 60) {
//        sleepLatency = 10;
//    }
//    
//    int totalSleepHour = totalSleepTime / 3600;
//    amountOfSleep = totalSleepHour * 10;
//    wakingEventsPoint = (wakingEvents > 2) ? -5 : 0;
//    sleepVSAwaketime = totalSleepTime > totalAwakeTime ? 10 : -10;
//
//    totalPoint = amountOfSleep + gotupFromBed + wakingEventsPoint + snoring + sleepLatency + sleepVSAwaketime;
//    
//    // 保存得分
//    WBSQLBuffer *pointSqlbuffer = [[WBSQLBuffer alloc] init];
//    pointSqlbuffer.REPLACE(@"SLEEPPROPERTY")
//    .SET(@"DATEYMD",@(currentDateymd))
//    .SET(@"AMOUNTOFSLEEP",@(amountOfSleep))
//    .SET(@"SLEEPVSAWAKE",@(sleepVSAwaketime))
//    .SET(@"SLEEPLATENCY",@(sleepLatency))
//    .SET(@"GOTUP",@(gotupFromBed))
//    .SET(@"WAKINGEVENTS",@(wakingEventsPoint))
//    .SET(@"SNORING",@(snoring))
//    .SET(@"TOTAL",@(totalPoint))
//    .SET(@"BPM",@(45 + arc4random() % 20))
//    .SET(@"BREATHSPM",@(15 + arc4random() % 5))
//    .SET(@"TOTALSLEEPTIME", @(totalSleepTime))
//    .WHERE([NSString stringWithFormat:@"%@=%ld", @"DATEYMD", (long)currentDateymd]);
//    WBDatabaseTransaction *pointUpdateTransaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:pointSqlbuffer];
//    [[WBDatabaseService defaultService] writeWithTransaction:pointUpdateTransaction completionBlock:^{
//        if (insertTransaction.resultSet.resultCode == HTDatabaseResultSucceed) {
//            NSLog(@"Analysing succeed2");
//        }
//    }];
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:WBDataAnalysingFinishedNotification object:nil];
//    
//}

- (NSArray *)querySleepData {
	NSMutableArray *mutableArr = [NSMutableArray array];
	NSDateFormatter *dateFormatter = nil;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
	NSString *sql = @"SELECT * FROM SLEEP , SLEEPPROPERTY WHERE SLEEP.DATEYMD = SLEEPPROPERTY.DATEYMD ORDER BY SLEEP.DATEYMD ASC";
	WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] initWithSQL:sql];
	WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlbuffer];
	[[WBDatabaseService defaultService] readWithTransaction:transaction completionBlock:^{}];
	for (NSDictionary *dictionary in transaction.resultSet.resultArray) {
		NSInteger tempDateymd = [dictionary integerForKey:@"DATEYMD"];
		WBSQLBuffer *stageSqlbuffer = [[WBSQLBuffer alloc] init];
		stageSqlbuffer.SELECT(@"*").FROM(@"SLEEPSTAGE").WHERE([NSString stringWithFormat:@"%@=%ld",@"DATEYMD", (long)(long)tempDateymd]).ORDERBY(@"STARTTIME",ASC);
		WBDatabaseTransaction *stageTransaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:stageSqlbuffer];
		[[WBDatabaseService defaultService] readWithTransaction:stageTransaction completionBlock:^{}];
		
		WBSleepInfo *sleepInfo = [[WBSleepInfo alloc] init];
		if ([dictionary stringForKey:@"DATEYMD"].length > 0) {
			sleepInfo.time = [[dateFormatter dateFromString:[dictionary stringForKey:@"DATEYMD"]] timeIntervalSince1970];
		}
        sleepInfo.toBedTime = [dictionary floatForKey:@"TOBEDTIME"];
        sleepInfo.fallAsleepTime = [dictionary floatForKey:@"FALLASLEEPTIME"];
        sleepInfo.gotupTime = [dictionary floatForKey:@"ENDTIME"];
        sleepInfo.bpm = [dictionary integerForKey:@"BPM"];
        sleepInfo.breathspm = [dictionary integerForKey:@"BREATHSPM"];
        sleepInfo.totalSleepTime = [dictionary floatForKey:@"TOTALSLEEPTIME"];

        WBSleepScore *score = [[WBSleepScore alloc] init];
        score.amountOfSleep = [dictionary integerForKey:@"AMOUNTOFSLEEP"];
        score.gotupFromBed = [dictionary integerForKey:@"GOTUP"];
        score.sleepVSAwake = [dictionary integerForKey:@"SLEEPVSAWAKE"];
        score.wakingEvents = [dictionary integerForKey:@"WAKINGEVENTS"];
        score.sleepLatency = [dictionary integerForKey:@"SLEEPLATENCY"];
        score.snoring = [dictionary integerForKey:@"SNORING"];
        sleepInfo.sleepScore = score;
        
        sleepInfo.improvementIdeas = [NSString stringWithFormat:@"Exercise regularly"];
        sleepInfo.improvementIdeasDetail = [NSString stringWithFormat:@"Aerobic exercise in the afternoon or at least 3 hours efore going to bed is good for sleep"];
        

		NSMutableArray *array = [NSMutableArray array];
		
        WBSleepPoint *lastSleepPoint;
        
		for (NSDictionary *stageDic in stageTransaction.resultSet.resultArray) {
			double startValue = [stageDic doubleForKey:@"STARTTIME"];
			double endValue = [stageDic doubleForKey:@"ENDTIME"];
			int stage = [stageDic intForKey:@"STAGE"];
			int sleepValue = [stageDic intForKey:@"DEEPVALUE"];

			WBSleepPoint *sleepPoint = [[WBSleepPoint alloc] init];
			sleepPoint.time = startValue;
			sleepPoint.state = stage;
			sleepPoint.sleepValue = sleepValue;
			
			WBSleepPoint *sleepPoint2 = [[WBSleepPoint alloc] init];
			sleepPoint2.time = endValue;
			sleepPoint2.state = stage;
			sleepPoint2.sleepValue = sleepValue;

			
            // 合并相同的点
            if (lastSleepPoint) {
                if (sleepPoint.state == lastSleepPoint.state ||
                    (sleepPoint.state >= WBSleepStageTypeFallasleepDeep && lastSleepPoint.state >= WBSleepStageTypeFallasleepDeep)) {
                    NSMutableArray *lastSegment = array.lastObject;
                    if (sleepPoint.time - lastSleepPoint.time > WBAnalyseTimeInterval) {
                        [lastSegment addObject:sleepPoint];
                    }
                    [lastSegment addObject:sleepPoint2];
                    
                    lastSleepPoint = sleepPoint2;

                    continue;
                } else {
                    if (sleepPoint.time - lastSleepPoint.time < 60) {
                        NSMutableArray *pointAray = [NSMutableArray array];
                        [pointAray addObject:sleepPoint2];
                        
                        [array addObject:pointAray];
                        lastSleepPoint = sleepPoint2;
                        
                        continue;
                    }
                }
            }
            
            NSMutableArray *pointAray = [NSMutableArray array];
            
            [pointAray addObject:sleepPoint];
            [pointAray addObject:sleepPoint2];
            
            [array addObject:pointAray];
            
            lastSleepPoint = sleepPoint2;
            
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
