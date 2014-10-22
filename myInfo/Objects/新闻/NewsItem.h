//
//  NewItem.h
//  ITInfo2
//
//  Created by JianShaoChen on 5/20/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject

@property (retain, nonatomic) NSMutableDictionary *newsItemDict;
@property (copy, nonatomic) NSString *newsid;
@property (copy, nonatomic) NSString *newstitle;
@property (copy, nonatomic) NSString *newscommentCount;
@property (copy, nonatomic) NSString *newsauthor;
@property (copy, nonatomic) NSString *newsauthorid;
@property (copy, nonatomic) NSString *newspubDate;
@property (copy, nonatomic) NSString *newsurl;
//@property (copy, nonatomic) NSString *newsType;

@end
