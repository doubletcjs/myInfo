//
//  NewsDetialItem.m
//  ITInfo2
//
//  Created by JianShaoChen on 5/20/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "NewsDetialItem.h"

@implementation NewsDetialItem

- (id)init
{
    self = [super init];
    _newsDetialItemDict = [[NSMutableDictionary alloc] init];
    _newsDetialRelativies = [[NSMutableArray alloc] init];
    _newsDetialid = @"newsDetialid";
    _newsDetialtitle = @"newsDetialtitle";
    _newsDetialurl = @"newsDetialurl";
    _newsDetialbody = @"newsDetialbody";
    _newsDetialauthor = @"newsDetialauthor";
    _newsDetialauthorid = @"newsDetialauthorid";
    _newsDetialpubDate = @"newsDetialpubDate";
    _newsDetialcommentCount = @"newsDetialcommentCount";
    _newsDetialsoftwarelink = @"newsDetialsoftwarelink";
    _newsDetialsoftwarename = @"newsDetialsoftwarename";
    _newsDetialfavorite = @"newsDetialfavorite";
    return self;
}

- (void)dealloc
{
    [_newsDetialItemDict removeAllObjects];
    [_newsDetialItemDict release];
    [_newsDetialRelativies removeAllObjects];
    [_newsDetialRelativies release];
    [_newsDetialid release];
    [_newsDetialtitle release];
    [_newsDetialurl release];
    [_newsDetialbody release];
    [_newsDetialauthor release];
    [_newsDetialauthorid release];
    [_newsDetialpubDate release];
    [_newsDetialcommentCount release];
    [_newsDetialsoftwarelink release];
    [_newsDetialsoftwarename release];
    [_newsDetialfavorite release];
    [super dealloc];
}

@end
