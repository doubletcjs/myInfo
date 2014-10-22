//
//  DetialViewController.h
//  myInfo
//
//  Created by JianShaoChen on 8/3/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetialViewController : UIViewController

@property (assign, nonatomic) requestType type;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIScrollView *detialScrollView;
@property (copy, nonatomic) NSString *itemId;

@property (copy, nonatomic) NSString *blogapp;
@property (copy, nonatomic) NSString *articlesTitle;
@property (copy, nonatomic) NSString *articlesDate;
@property (copy, nonatomic) NSString *articlesSource;
@property (copy, nonatomic) NSString *articlesLink;
@property (copy, nonatomic) NSString *commentCount;

//收藏
@property (copy, nonatomic) NSString *collectionType;
@property (copy, nonatomic) NSString *collectionId;
@property (copy, nonatomic) NSString *collectionTitle;
@property (copy, nonatomic) NSString *collectionHtmlContent; 

@end
