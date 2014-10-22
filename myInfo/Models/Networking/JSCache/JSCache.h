//
//  JSCache.h
//  NutritionFactsLabel
//
//  Created by JianShaoChen on 14-9-10.
//  Copyright (c) 2014年 Sam Cooper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSCache : NSObject

+ (void)setObject:(NSMutableData *)dataObject forKey:(NSString *)key;
+ (NSMutableData *)objectForKey:(NSString *)key;
@end
