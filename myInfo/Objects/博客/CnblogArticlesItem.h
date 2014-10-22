//
//  CnblogHotNewsItem.h
//  ITInfo2
//
//  Created by JianShaoChen on 5/21/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CnblogArticlesItem : NSObject

@property (retain, nonatomic) NSMutableDictionary *cnblogArticlesItemDict;
@property (copy, nonatomic) NSString *cnblogArticlesid;
@property (copy, nonatomic) NSString *cnblogArticlestitle;
@property (copy, nonatomic) NSString *cnblogArticlessummary;
@property (copy, nonatomic) NSString *cnblogArticlespublished;
@property (copy, nonatomic) NSString *cnblogArticlesupdated;
@property (copy, nonatomic) NSString *cnblogArticleslink;
@property (copy, nonatomic) NSString *cnblogArticlesblogapp;
@property (copy, nonatomic) NSString *cnblogArticlesdiggs;
@property (copy, nonatomic) NSString *cnblogArticlesviews;
@property (copy, nonatomic) NSString *cnblogArticlescomments; 

@property (copy, nonatomic) NSString *cnblogArticlesauthorname;
@property (copy, nonatomic) NSString *cnblogArticlesauthoruri;
@property (copy, nonatomic) NSString *cnblogArticlesauthoravatar;

@end
