//
//  SimpleViewController.h
//  ITInfo2
//
//  Created by JianShaoChen on 5/24/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleWebViewController : UIViewController <UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (copy, nonatomic) NSString *url;
@property (retain, nonatomic) IBOutlet UIToolbar *buttomToolBar;

- (IBAction)openSafari:(id)sender;
- (IBAction)refresh:(id)sender;

@end
