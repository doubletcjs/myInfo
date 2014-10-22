//
//  CnblogNewsItem.h
//  ITInfo2
//
//  Created by JianShaoChen on 5/21/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CnblogNewsItem : NSObject

@property (retain, nonatomic) NSMutableDictionary *cnblogNewsItemDict;
@property (copy, nonatomic) NSString *cnblogNewsid;
@property (copy, nonatomic) NSString *cnblogNewstitle;
@property (copy, nonatomic) NSString *cnblogNewssummary;
@property (copy, nonatomic) NSString *cnblogNewspublished;
@property (copy, nonatomic) NSString *cnblogNewsupdated;
@property (copy, nonatomic) NSString *cnblogNewslink;
@property (copy, nonatomic) NSString *cnblogNewsdiggs;
@property (copy, nonatomic) NSString *cnblogNewsviews;
@property (copy, nonatomic) NSString *cnblogNewscomments;
@property (copy, nonatomic) NSString *cnblogNewstopic;
@property (copy, nonatomic) NSString *cnblogNewstopicIcon;
@property (copy, nonatomic) NSString *cnblogNewssourceName;

@end
