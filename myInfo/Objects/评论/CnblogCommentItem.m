//
//  CommentItem.m
//  ITInfo
//
//  Created by JianShaoChen on 2/22/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "CnblogCommentItem.h"

@implementation CnblogCommentItem

- (id)init
{
    self = [super init];
    _cnblogCommentsItemDict = [[NSMutableDictionary alloc] init];
    _cnblogCommentsid = @"cnblogCommentsid";
    _cnblogCommentstitle = @"cnblogCommentstitle";
    _cnblogCommentspublished = @"cnblogCommentspublished";
    _cnblogCommentsupdated = @"cnblogCommentsupdated";
    _cnblogCommentsauthorname = @"cnblogCommentsauthorname";
    _cnblogCommentsauthoruri = @"cnblogCommentsauthoruri";
    _cnblogCommentscontent = @"cnblogCommentscontent";
    return self;
}

- (void)dealloc
{
    [_cnblogCommentsItemDict removeAllObjects];
    [_cnblogCommentsItemDict release];
    [_cnblogCommentsid release];
    [_cnblogCommentstitle release];
    [_cnblogCommentspublished release];
    [_cnblogCommentsupdated release];
    [_cnblogCommentsauthorname release];
    [_cnblogCommentsauthoruri release];
    [_cnblogCommentscontent release];
    [super dealloc];
}

@end
