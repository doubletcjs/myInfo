//
//  SearchItem.h
//  myInfo
//
//  Created by JianShaoChen on 5/22/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchItem : NSObject

@property (retain, nonatomic) NSMutableDictionary *searchItemsDict;

@property (copy, nonatomic) NSString *searchItemsobjid;
@property (copy, nonatomic) NSString *searchItemstype;
@property (copy, nonatomic) NSString *searchItemstitle;
@property (copy, nonatomic) NSString *searchItemsurl;
@property (copy, nonatomic) NSString *searchItemspubDate;
@property (copy, nonatomic) NSString *searchItemsauthor;
@end
