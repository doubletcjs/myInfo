//
//  CnblogNewsDetialItem.h
//  ITInfo2
//
//  Created by JianShaoChen on 5/21/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CnblogNewsDetialItem : NSObject

@property (strong, nonatomic) NSMutableDictionary *cnblogNewsDetialItemDict;

@property (copy, nonatomic) NSString *cnblogNewsDetialTitle;
@property (copy, nonatomic) NSString *cnblogNewsDetialSourceName;
@property (copy, nonatomic) NSString *cnblogNewsDetialSubmitDate;
@property (copy, nonatomic) NSString *cnblogNewsDetialContent;
@property (copy, nonatomic) NSString *cnblogNewsDetialImageUrl;
@property (copy, nonatomic) NSString *cnblogNewsDetialPrevNews;
@property (copy, nonatomic) NSString *cnblogNewsDetialNextNews;
@property (copy, nonatomic) NSString *cnblogNewsDetialCommentCount;

@end
