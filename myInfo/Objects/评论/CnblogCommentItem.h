//
//  CommentItem.h
//  ITInfo
//
//  Created by JianShaoChen on 2/22/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CnblogCommentItem : NSObject

@property (strong, nonatomic) NSMutableDictionary *cnblogCommentsItemDict;

@property (copy, nonatomic) NSString *cnblogCommentsid;
@property (copy, nonatomic) NSString *cnblogCommentstitle;
@property (copy, nonatomic) NSString *cnblogCommentspublished;
@property (copy, nonatomic) NSString *cnblogCommentsupdated;
@property (copy, nonatomic) NSString *cnblogCommentsauthorname;
@property (copy, nonatomic) NSString *cnblogCommentsauthoruri;
@property (copy, nonatomic) NSString *cnblogCommentscontent;

@end
