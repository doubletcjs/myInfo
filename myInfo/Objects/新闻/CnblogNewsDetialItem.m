//
//  CnblogNewsDetialItem.m
//  ITInfo2
//
//  Created by JianShaoChen on 5/21/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "CnblogNewsDetialItem.h"

@implementation CnblogNewsDetialItem

- (id)init
{
    self = [super init];
    _cnblogNewsDetialItemDict = [[NSMutableDictionary alloc] init];
    _cnblogNewsDetialTitle = @"cnblogNewsDetialTitle";
    _cnblogNewsDetialSourceName = @"cnblogNewsDetialSourceName";
    _cnblogNewsDetialSubmitDate = @"cnblogNewsDetialSubmitDate";
    _cnblogNewsDetialContent = @"cnblogNewsDetialContent";
    _cnblogNewsDetialImageUrl = @"cnblogNewsDetialImageUrl";
    _cnblogNewsDetialPrevNews = @"cnblogNewsDetialPrevNews";
    _cnblogNewsDetialNextNews = @"cnblogNewsDetialNextNews";
    _cnblogNewsDetialCommentCount = @"cnblogNewsDetialCommentCount";
    return self;
}

- (void)dealloc
{
    [_cnblogNewsDetialItemDict removeAllObjects];
    [_cnblogNewsDetialItemDict release];
    [_cnblogNewsDetialTitle release];
    [_cnblogNewsDetialSourceName release];
    [_cnblogNewsDetialSubmitDate release];
    [_cnblogNewsDetialContent release];
    [_cnblogNewsDetialImageUrl release];
    [_cnblogNewsDetialPrevNews release];
    [_cnblogNewsDetialNextNews release];
    [_cnblogNewsDetialCommentCount release];
    [super dealloc];
}

@end
