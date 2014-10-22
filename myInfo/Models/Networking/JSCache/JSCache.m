//
//  JSCache.m
//  NutritionFactsLabel
//
//  Created by JianShaoChen on 14-9-10.
//  Copyright (c) 2014年 Sam Cooper Studio. All rights reserved.
//

#import "JSCache.h"

static NSTimeInterval cacheOverdueTime = (double)60*20;//1*60 1分钟
static NSString *baseCachePath = @"Caches/JSCaches";
static NSString *cacheKey = @"JSCacheStorageKey";

@implementation JSCache

#pragma mark - 清空缓存目录
+ (void)resetCache
{
	[[NSFileManager defaultManager] removeItemAtPath:[JSCache cacheDirectory] error:nil];
}
#pragma mark - 缓存目录
+ (NSString*)cacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:baseCachePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
	return path;
}
#pragma mark - 缓存数据
+ (void)writeToFile:(NSString *)fileName withData:(NSData *)data
{
    NSError *error;
	@try {
		[data writeToFile:fileName options:NSDataWritingAtomic error:&error];
	}
	@catch (NSException * e) {
		//TODO: error handling maybe
	}
}

+ (void)setObject:(NSMutableData *)dataObject forKey:(NSString *)key
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    if (![fileManager fileExistsAtPath:filename]) {
        [self writeToFile:filename withData:dataObject];
    } else {
        NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
        NSMutableData *data = [NSMutableData dataWithContentsOfFile:filename];
        
        if (ABS([modificationDate timeIntervalSinceNow]) >= cacheOverdueTime) {
            NSLog(@"缓存过期");
            [self writeToFile:filename withData:dataObject];
        } else {
            if (![data isEqualToData:dataObject]) {
                [self writeToFile:filename withData:dataObject];
            } else {
                NSLog(@"%f秒后过期", cacheOverdueTime - ABS([modificationDate timeIntervalSinceNow]));
            }
        }
    }
}
#pragma mark - 读取缓存数据，是否存在、是否过期
+ (NSMutableData *)objectForKey:(NSString *)key
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
	
	if ([fileManager fileExistsAtPath:filename]) {
        NSMutableData *data = [NSMutableData dataWithContentsOfFile:filename];
        if (data) {
            return data;
        } else {
            return nil;
        }
	}
    
	return nil;
}
#pragma mark - 转换时间显示
+ (NSString *)changeDate:(NSDate *)fromDate
{
    NSTimeInterval timeInterval = cacheOverdueTime-ABS([fromDate timeIntervalSinceNow]);
    
    long temp = 0;
    NSString *result = @"";
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    } else if((temp = timeInterval/60) < 60) {
        result = [NSString stringWithFormat:@"%d分后过期", (int)temp];
    } else if((temp = temp/60) < 24) {
        result = [NSString stringWithFormat:@"%d小时后过期", (int)temp];
    } else if((temp = temp/24) < 30) {
        result = [NSString stringWithFormat:@"%d天后过期", (int)temp];
    } else if((temp = temp/30) < 12) {
        result = [NSString stringWithFormat:@"%d月后过期", (int)temp];
    } else {
        //temp = temp/12;
        //result = [NSString stringWithFormat:@"%d年前", (int)temp];
        
        result = [NSString stringWithFormat:@"%@", fromDate];
        result = [result stringByReplacingOccurrencesOfString:@" +0000" withString:@""];
    }
    
    return  result;
}

@end
