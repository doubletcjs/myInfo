//
//  JSNetworkEngine.h
//  JSNetworkEngine
//
//  Created by kaykwai on 14-8-11.
//  Copyright (c) 2014年 com.i-mybest. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    engineStyleNormal = 0,
    engineStyleNoUI = 1,
    engineStyleOnlyLoading = 2
} JSEngineStyle;

typedef void (^ComplectionHandle) (NSMutableData *resultData, NSError *error);

@interface JSNetworkEngine : UIView

@property (nonatomic, assign) JSEngineStyle engineStyle;

- (id)initStyle:(JSEngineStyle)engineStyle;
/**
 是否开启缓存
 */
@property (nonatomic, assign) BOOL cacheData;
/**
 请求超时，默认20秒
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/**
 默认10分钟后 更新缓存 如果有缓存
 */
@property (nonatomic, assign) NSTimeInterval cacheLimitInterval;

@property (nonatomic, copy) ComplectionHandle complectionHandle;

- (void)startNetworkEngine:(NSString *)urlPath withMethod:(NSString *)method params:(NSDictionary *)parames withHandle:(ComplectionHandle)handle;

//解析JSON
+ (id)responseJSON:(id)data;
//解析XML
+ (id)responseXML:(id)data;
@end
