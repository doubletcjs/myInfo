//
//  NewItem.m
//  ITInfo2
//
//  Created by JianShaoChen on 5/20/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "NewsItem.h"

@implementation NewsItem

- (id)init
{
    self = [super init];
    _newsItemDict = [[NSMutableDictionary alloc] init];
    _newsid = @"newsid";
    _newstitle = @"newstitle";
    _newscommentCount = @"newscommentCount";
    _newsauthor = @"newsauthor";
    _newsauthorid = @"newsauthorid";
    _newspubDate = @"newspubDate";
    _newsurl = @"newsurl";
    return self;
}

- (void)dealloc
{
    [_newsItemDict removeAllObjects];
    [_newsItemDict release];
    [_newsid release];
    [_newstitle release];
    [_newscommentCount release];
    [_newsauthor release];
    [_newsauthorid release];
    [_newspubDate release];
    [_newsurl release];
    [super dealloc];
}

@end
