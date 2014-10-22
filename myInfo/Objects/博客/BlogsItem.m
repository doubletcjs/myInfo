//
//  blogsItem.m
//  ITInfo2
//
//  Created by JianShaoChen on 5/20/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "BlogsItem.h"

@implementation BlogsItem

- (id)init
{
    self = [super init];
    _blogsItemDict = [[NSMutableDictionary alloc] init];
    _blogsid = @"blogsid";
    _blogstitle = @"blogstitle";
    _blogscommentCount = @"blogscommentCount";
    _blogsauthoruid = @"blogsauthoruid";
    _blogsauthorname = @"blogsauthorname";
    _blogspubDate = @"blogspubDate";
    _blogsurl = @"blogsurl";
    _blogsdocumentType = @"blogsdocumentType";
    return self;
}

- (void)dealloc
{
    [_blogsItemDict removeAllObjects];
    [_blogsItemDict release];
    [_blogsid release];
    [_blogstitle release];
    [_blogscommentCount release];
    [_blogsauthoruid release];
    [_blogsauthorname release];
    [_blogspubDate release];
    [_blogsurl release];
    [_blogsdocumentType release];
    
    [super dealloc];
}

@end
