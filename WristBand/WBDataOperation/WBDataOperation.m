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

@interface WBDataOperation ()
{
    NSMutableString *mutableString;
	NSInteger dateymd;
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
	NSString *date = [[NSDate date] stringWithFormat:@"yyyyMMdd"];
	dateymd = [date longLongValue];
	NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
	WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] init];
	sqlbuffer.SELECT(@"*").FROM(@"SLEEP").WHERE([NSString stringWithFormat:@"%@=%ld", @"DATEYMD", (long)dateymd]);
	WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlbuffer];
	[[WBDatabaseService defaultService] readWithTransaction:transaction completionBlock:^{
		if (transaction.resultSet.resultArray.count == 0) {
			WBSQLBuffer *insertSqlbuffer = [[WBSQLBuffer alloc] init];
			insertSqlbuffer.INSERT(@"SLEEP").SET(@"DATEYMD",@(dateymd)).SET(@"STARTTIME",@(timestamp));
			WBDatabaseTransaction *insertTransaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:insertSqlbuffer];
			[[WBDatabaseService defaultService] writeWithTransaction:insertTransaction completionBlock:^{
				if (insertTransaction.resultSet.resultCode == HTDatabaseResultSucceed) {
					
				}
			}];
		}
	}];
}

- (void)bleDidReceiveData:(UInt16)value {
    NSString *string = [NSString stringWithFormat:@"%4d,%.3f;", value, [[NSDate date] timeIntervalSince1970]];
    [mutableString appendString:string];
}

- (void)analysing {
	NSMutableArray *sleepStagesArray = [NSMutableArray array];
	
    NSString *string = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test2" ofType:@"rtf"] encoding:NSUTF8StringEncoding error:NULL];
//    NSArray *dataArray = [mutableString componentsSeparatedByString:@";"];
    NSArray *dataArray = [string componentsSeparatedByString:@";"];
    
    NSMutableArray *intervalArray = [NSMutableArray array];
    
    // 算出每两个值之间的差值
    for (NSInteger i = 0; i < dataArray.count; i++) {
        NSString *string = [dataArray objectAtIndex:i];
        WBDataItem *item = [[WBDataItem alloc] initWithString:string];
        
        if (i + 1 < dataArray.count) {
            NSString *string1 = [dataArray objectAtIndex:i + 1];
            WBDataItem *item1 = [[WBDataItem alloc] initWithString:string1];
            
            [intervalArray addObject:@(ABS(item1.value - item.value))];
        }
    }
    
    NSMutableArray *tempDataArray = [NSMutableArray arrayWithArray:dataArray];
    NSMutableArray *tempIntervalArray = [NSMutableArray arrayWithArray:intervalArray];
	
	
    // 找出空载的时间: 平均值少于18,时间大于15秒
    for (NSInteger i = 0; i < intervalArray.count; ) {
        long long total = 0;
        
        NSInteger j = i;
        do {
            UInt16 interval = [[intervalArray objectAtIndex:j] integerValue];
            total += interval;
            j++;
        } while (total / (float)(j - i) < 18 && j < intervalArray.count);
        
//        NSLog(@"j - i = %d , j = %d, intervale = %ld", j - i, j, [[intervalArray objectAtIndex:j] integerValue]);

        if (j - i >= 15 * 5) {
			WBDataItem *item1 = [[WBDataItem alloc] initWithString:[dataArray objectAtIndex:i]];
			WBDataItem *item2 = [[WBDataItem alloc] initWithString:[dataArray objectAtIndex:j - i - 1]];
			WBSleepStage *sleepStage = [[WBSleepStage alloc] init];
			sleepStage.type = WBSleepStageTypeAway;
			sleepStage.startTimeStamp = item1.timeStamp;
			sleepStage.endTimeStamp = item2.timeStamp;
			[sleepStagesArray addObject:sleepStage];
			
            [tempDataArray removeObjectsInRange:NSMakeRange(i, j - i)];
            [tempIntervalArray removeObjectsInRange:NSMakeRange(i, j - i)];
        }
        
        if (j >= intervalArray.count - 10) {
            break;
        }
        
        i = j;
        
    }
	
    dataArray = [NSArray arrayWithArray:tempDataArray];
	
    // 找出醒着的时间，五分钟之内<100,>1800的次数超过50次
	NSInteger Lessthan100 = 0;
	NSInteger greaterThan1800 = 0;
	WBDataItem *startDataItem = nil;
	NSInteger startIndex = 0;
	WBSleepStage *lastSleepStage = nil;
    for (NSInteger i = 0; i < dataArray.count; i++) {
		NSString *string = [dataArray objectAtIndex:i];
		WBDataItem *item = [[WBDataItem alloc] initWithString:string];
		if (!startDataItem) {
			startDataItem = item;
			startIndex = i;
		}
		
		if (item.timeStamp - startDataItem.timeStamp > 5 * 60) {
			WBSleepStage *sleepStage = nil;
			if (Lessthan100 + greaterThan1800 > 50) {
				sleepStage = [[WBSleepStage alloc] init];
				sleepStage.type = WBSleepStageTypeAwake;
				sleepStage.startTimeStamp = startDataItem.timeStamp;
				sleepStage.endTimeStamp = item.timeStamp;
				sleepStage.startTag = startIndex;
				sleepStage.endTag = i;
			}
			
			if (!sleepStage) {
				if (lastSleepStage) {
					[sleepStagesArray addObject:lastSleepStage];
					[tempDataArray removeObjectsInRange:NSMakeRange(lastSleepStage.startTag, lastSleepStage.endTag - lastSleepStage.startTag)];
					lastSleepStage = nil;
				}
			} else {
				if (!lastSleepStage) {
					lastSleepStage = sleepStage;
				} else {
					if (sleepStage.startTimeStamp - lastSleepStage.endTimeStamp <= 2 * 60) {
						lastSleepStage.endTimeStamp = sleepStage.endTimeStamp;
						lastSleepStage.endTag = i;
					} else {
						[sleepStagesArray addObject:lastSleepStage];
						[tempDataArray removeObjectsInRange:NSMakeRange(lastSleepStage.startTag, lastSleepStage.endTag - lastSleepStage.startTag)];
						lastSleepStage = sleepStage;
					}
				}
			}
			
			startDataItem = nil;
			Lessthan100 = 0;
			greaterThan1800 = 0;
			
			continue;
		}
		
		if (item.value < 100) {
			Lessthan100++;
		} else if (item.value > 1800) {
			greaterThan1800++;
		}
    }
	
	if (lastSleepStage) {
		[sleepStagesArray addObject:lastSleepStage];
		[tempDataArray removeObjectsInRange:NSMakeRange(lastSleepStage.startTag, lastSleepStage.endTag - lastSleepStage.startTag)];
	}
	
	dataArray = [NSArray arrayWithArray:tempDataArray];
	
	// 找出深睡的时间，电压值在<850,1150>之间变化
	
	startDataItem = nil;
	startIndex = 0;
	for (NSInteger i = 0; i < dataArray.count; i++) {
		NSString *string = [dataArray objectAtIndex:i];
		WBDataItem *item = [[WBDataItem alloc] initWithString:string];
		if (!startDataItem) {
			startDataItem = item;
			startIndex = i;
		}
		if (item.value >= 800 && item.value <= 1200) {
			continue;
		} else {
			if (i - startIndex >= 1 * 30 * 5) {
				WBSleepStage *sleepStage = [[WBSleepStage alloc] init];
				sleepStage.type = WBSleepStageTypeFallasleepDeep;
				sleepStage.startTimeStamp = startDataItem.timeStamp;
				sleepStage.endTimeStamp = item.timeStamp;
				[sleepStagesArray addObject:sleepStage];
			}
			startDataItem = nil;
			startIndex = 0;
		}
	}
	
	// 其余的就是浅睡的时间
	WBMutableSQLBuffer *mutableSqlBuffer = [[WBMutableSQLBuffer alloc] init];
	for (WBSleepStage *sleepStage in sleepStagesArray) {
		WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] init];
		sqlbuffer.INSERT(@"SLEEPSTAGE")
		.SET(@"DATEYMD",@(dateymd))
		.SET(@"ENDTIME",@(sleepStage.endTimeStamp))
		.SET(@"STARTTIME",@(sleepStage.startTimeStamp))
		.SET(@"STAGE",@(sleepStage.type));
		[mutableSqlBuffer addBuffer:sqlbuffer];
	}
	
	WBDatabaseTransaction *insertTransaction = [[WBDatabaseTransaction alloc] initWithMutalbeSQLBuffer:mutableSqlBuffer];
	[[WBDatabaseService defaultService] writeWithTransaction:insertTransaction completionBlock:^{
		if (insertTransaction.resultSet.resultCode == HTDatabaseResultSucceed) {
			
		}
	}];
	

}

- (NSArray *)querySleepData {
	NSMutableArray *mutableArr = [NSMutableArray array];
	NSDateFormatter *dateFormatter = nil;
	
	NSString *sql = @"SELECT * FROM SLEEP";
	WBSQLBuffer *sqlbuffer = [[WBSQLBuffer alloc] initWithSQL:sql];
	WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sqlbuffer];
	[[WBDatabaseService defaultService] readWithTransaction:transaction completionBlock:^{}];
	for (NSDictionary *dictionary in transaction.resultSet.resultArray) {
		NSInteger tempDateymd = [[dictionary objectForKey:@"DATEYMD"] longLongValue];
		WBSQLBuffer *stageSqlbuffer = [[WBSQLBuffer alloc] init];
		stageSqlbuffer.SELECT(@"*").FROM(@"SLEEPSTAGE").WHERE([NSString stringWithFormat:@"%@=%ld",@"DATEYMD", tempDateymd]).ORDERBY(@"STARTTIME",ASC);
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
		
		
		sleepInfo.sleepPoints = [NSArray arrayWithArray:array];
		[sleepInfo setup];
		
		[mutableArr addObject:sleepInfo];
	}

	
	return mutableArr;
}

@end
