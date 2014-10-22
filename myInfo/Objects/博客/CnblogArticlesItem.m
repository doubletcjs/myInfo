//
//  CnblogHotNewsItem.m
//  ITInfo2
//
//  Created by JianShaoChen on 5/21/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "CnblogArticlesItem.h"

@implementation CnblogArticlesItem

- (id)init
{
    self = [super init];
    _cnblogArticlesItemDict = [[NSMutableDictionary alloc] init];
    _cnblogArticlesid = @"cnblogArticlesid";
    _cnblogArticlestitle = @"cnblogArticlestitle";
    _cnblogArticlessummary = @"cnblogArticlessummary";
    _cnblogArticlespublished = @"cnblogArticlespublished";
    _cnblogArticlesupdated = @"cnblogArticlesupdated"; 
    _cnblogArticleslink = @"cnblogArticleslink";
    _cnblogArticlesblogapp = @"cnblogArticlesblogapp";
    _cnblogArticlesdiggs = @"cnblogArticlesdiggs";
    _cnblogArticlesviews = @"cnblogArticlesviews";
    _cnblogArticlescomments = @"cnblogArticlescomments";
    
    _cnblogArticlesauthorname = @"cnblogArticlesauthorname";
    _cnblogArticlesauthoruri = @"cnblogArticlesauthoruri";
    _cnblogArticlesauthoravatar = @"cnblogArticlesauthoravatar";
    return self;
}

- (void)dealloc
{
    [_cnblogArticlesItemDict removeAllObjects];
    [_cnblogArticlesItemDict release];
    [_cnblogArticlesid release];
    [_cnblogArticlestitle release];
    [_cnblogArticlessummary release];
    [_cnblogArticlespublished release];
    [_cnblogArticlesupdated release];
    [_cnblogArticleslink release];
    [_cnblogArticlesblogapp release];
    [_cnblogArticlesdiggs release];
    [_cnblogArticlesviews release];
    [_cnblogArticlescomments release];
    
    [_cnblogArticlesauthorname release];
    [_cnblogArticlesauthoruri release];
    [_cnblogArticlesauthoravatar release];
    [super dealloc];
}

@end
