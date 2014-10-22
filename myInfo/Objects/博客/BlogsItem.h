//
//  blogsItem.h
//  ITInfo2
//
//  Created by JianShaoChen on 5/20/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogsItem : NSObject

@property (retain, nonatomic) NSMutableDictionary *blogsItemDict;
@property (copy, nonatomic) NSString *blogsid;
@property (copy, nonatomic) NSString *blogstitle;
@property (copy, nonatomic) NSString *blogsurl;
@property (copy, nonatomic) NSString *blogspubDate;
@property (copy, nonatomic) NSString *blogsauthoruid;
@property (copy, nonatomic) NSString *blogsauthorname;
@property (copy, nonatomic) NSString *blogscommentCount;
@property (copy, nonatomic) NSString *blogsdocumentType;

@end
