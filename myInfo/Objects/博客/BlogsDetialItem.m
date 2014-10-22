//
//  BlogsDetialItem.m
//  ITInfo2
//
//  Created by JianShaoChen on 5/21/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "BlogsDetialItem.h"

@implementation BlogsDetialItem

- (id)init
{
    self = [super init];
    _blogsDetialItemDict = [[NSMutableDictionary alloc] init];
    
    _blogsDetialid = @"blogsDetialid";
    _blogsDetialtitle = @"blogsDetialtitle";
    _blogsDetialurl = @"blogsDetialurl";
    _blogsDetialbody = @"blogsDetialbody";
    _blogsDetialauthor = @"blogsDetialauthor";
    _blogsDetialauthorid = @"blogsDetialauthorid";
    _blogsDetialpubDate = @"blogsDetialpubDate";
    _blogsDetialcommentCount = @"blogsDetialcommentCount";
    _blogsDetialdocumentType = @"blogsDetialdocumentType";
    _blogsDetialfavorite = @"blogsDetialfavorite";
    _blogsDetialwhere = @"blogsDetialwhere";
    return self;
}

- (void)dealloc
{
    [_blogsDetialItemDict removeAllObjects];
    [_blogsDetialItemDict release];
    
    [_blogsDetialid release];
    [_blogsDetialtitle release];
    [_blogsDetialurl release];
    [_blogsDetialbody release];
    [_blogsDetialauthor release];
    [_blogsDetialauthorid release];
    [_blogsDetialpubDate release];
    [_blogsDetialcommentCount release];
    [_blogsDetialdocumentType release];
    [_blogsDetialfavorite release];
    [_blogsDetialwhere release];
    [super dealloc];
}

@end
