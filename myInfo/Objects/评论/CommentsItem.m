//
//  CommentsItem.m
//  ITInfo2
//
//  Created by JianShaoChen on 5/22/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "CommentsItem.h"

@implementation CommentsItem

- (id)init
{
    self = [super init];
    _commentsItemDict = [[NSMutableDictionary alloc] init];
    _commentsid = @"commentsid";
    _commentsportrait = @"commentsportrait";
    _commentsauthor = @"commentsauthor";
    _commentsauthorid = @"commentsauthorid";
    _commentscontent = @"commentscontent";
    _commentspubDate = @"commentspubDate";
    _commentsappclient = @"commentsappclient";
    
    _commentsrefers = [[NSMutableArray alloc] init];
    
    _commentsrefertitle = @"commentsrefertitle";
    _commentsreferbody = @"commentsreferbody";
    return self;
}

- (void)dealloc
{
    [_commentsItemDict removeAllObjects];
    [_commentsItemDict release];
    [_commentsid release];
    [_commentsportrait release];
    [_commentsauthor release];
    [_commentsauthorid release];
    [_commentscontent release];
    [_commentspubDate release];
    [_commentsappclient release];
    
    [_commentsrefers removeAllObjects];
    [_commentsrefers release];
    
    [_commentsrefertitle release];
    [_commentsreferbody release];
    [super dealloc];
}

@end
