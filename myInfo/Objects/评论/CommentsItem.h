//
//  CommentsItem.h
//  ITInfo2
//
//  Created by JianShaoChen on 5/22/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsItem : NSObject

@property (strong, nonatomic) NSMutableDictionary *commentsItemDict;

@property (copy, nonatomic) NSString *commentsid;
@property (copy, nonatomic) NSString *commentsportrait;
@property (copy, nonatomic) NSString *commentsauthor;
@property (copy, nonatomic) NSString *commentsauthorid;
@property (copy, nonatomic) NSString *commentscontent;
@property (copy, nonatomic) NSString *commentspubDate;
@property (copy, nonatomic) NSString *commentsappclient;

@property (strong, nonatomic) NSMutableArray *commentsrefers;

@property (copy, nonatomic) NSString *commentsrefertitle;
@property (copy, nonatomic) NSString *commentsreferbody;
@end
