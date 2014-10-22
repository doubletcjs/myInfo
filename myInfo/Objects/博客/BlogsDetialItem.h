//
//  BlogsDetialItem.h
//  ITInfo2
//
//  Created by JianShaoChen on 5/21/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogsDetialItem : NSObject

@property (strong, nonatomic) NSMutableDictionary *blogsDetialItemDict;

@property (copy, nonatomic) NSString *blogsDetialid;
@property (copy, nonatomic) NSString *blogsDetialtitle;
@property (copy, nonatomic) NSString *blogsDetialurl;
@property (copy, nonatomic) NSString *blogsDetialwhere;
@property (copy, nonatomic) NSString *blogsDetialbody;
@property (copy, nonatomic) NSString *blogsDetialauthor;
@property (copy, nonatomic) NSString *blogsDetialauthorid;
@property (copy, nonatomic) NSString *blogsDetialdocumentType;
@property (copy, nonatomic) NSString *blogsDetialpubDate;
@property (copy, nonatomic) NSString *blogsDetialfavorite;
@property (copy, nonatomic) NSString *blogsDetialcommentCount;

@end
