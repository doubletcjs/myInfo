//
//  SearchItem.m
//  myInfo
//
//  Created by JianShaoChen on 5/22/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "SearchItem.h"

@implementation SearchItem

- (id)init
{
    self = [super init];
    _searchItemsDict = [[NSMutableDictionary alloc] init];
    _searchItemsobjid = @"searchItemsobjid";
    _searchItemstype = @"searchItemstype";
    _searchItemstitle = @"searchItemstitle";
    _searchItemsurl = @"searchItemsurl";
    _searchItemspubDate = @"searchItemspubDate";
    _searchItemsauthor = @"searchItemsauthor";
    return self;
}

- (void)dealloc
{
    [_searchItemsDict removeAllObjects];
    [_searchItemsDict release];
    [_searchItemsobjid release];
    [_searchItemstype release];
    [_searchItemstitle release];
    [_searchItemsurl release];
    [_searchItemspubDate release];
    [_searchItemsauthor release];
    [super dealloc];
}

@end
