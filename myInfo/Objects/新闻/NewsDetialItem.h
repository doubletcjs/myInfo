//
//  NewsDetialItem.h
//  ITInfo2
//
//  Created by JianShaoChen on 5/20/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsDetialItem : NSObject

@property (strong, nonatomic) NSMutableDictionary *newsDetialItemDict;

@property (copy, nonatomic) NSString *newsDetialid;
@property (copy, nonatomic) NSString *newsDetialtitle;
@property (copy, nonatomic) NSString *newsDetialurl;
@property (copy, nonatomic) NSString *newsDetialbody;
@property (copy, nonatomic) NSString *newsDetialauthor;
@property (copy, nonatomic) NSString *newsDetialauthorid;
@property (copy, nonatomic) NSString *newsDetialpubDate;
@property (copy, nonatomic) NSString *newsDetialcommentCount;
@property (copy, nonatomic) NSString *newsDetialsoftwarelink;
@property (copy, nonatomic) NSString *newsDetialsoftwarename;
@property (copy, nonatomic) NSString *newsDetialfavorite;

@property (strong, nonatomic) NSMutableArray *newsDetialRelativies;

@end
