//
//  CnblogNewsItem.m
//  ITInfo2
//
//  Created by JianShaoChen on 5/21/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "CnblogNewsItem.h"

@implementation CnblogNewsItem

- (id)init
{
    self = [super init];
    _cnblogNewsItemDict = [[NSMutableDictionary alloc] init];
    _cnblogNewsid = @"cnblogNewsid";
    _cnblogNewstitle = @"cnblogNewstitle";
    _cnblogNewssummary = @"cnblogNewssummary";
    _cnblogNewspublished = @"cnblogNewspublished";
    _cnblogNewsupdated = @"cnblogNewsupdated";
    _cnblogNewslink = @"cnblogNewslink";
    _cnblogNewsdiggs = @"cnblogNewsdiggs";
    _cnblogNewsviews = @"cnblogNewsviews";
    _cnblogNewscomments = @"cnblogNewscomments";
    _cnblogNewstopic = @"cnblogNewstopic";
    _cnblogNewstopicIcon = @"cnblogNewstopicIcon";
    _cnblogNewssourceName = @"cnblogNewssourceName";
    return self;
}

- (void)dealloc
{
    [_cnblogNewsItemDict removeAllObjects];
    [_cnblogNewsItemDict release];
    [_cnblogNewsid release];
    [_cnblogNewstitle release];
    [_cnblogNewssummary release];
    [_cnblogNewspublished release];
    [_cnblogNewsupdated release];
    [_cnblogNewslink release];
    [_cnblogNewsdiggs release];
    [_cnblogNewsviews release];
    [_cnblogNewscomments release];
    [_cnblogNewstopic release];
    [_cnblogNewstopicIcon release];
    [_cnblogNewssourceName release];
    [super dealloc];
}

@end
