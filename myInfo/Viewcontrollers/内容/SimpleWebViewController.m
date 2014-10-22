//
//  SimpleViewController.m
//  ITInfo2
//
//  Created by JianShaoChen on 5/24/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "SimpleWebViewController.h"

@interface SimpleWebViewController ()

@end

@implementation SimpleWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"博客新闻";
    
    self.view.backgroundColor = RGBColor(235, 235, 235, 1.0f);
    _buttomToolBar.backgroundColor = self.view.backgroundColor;
    [_buttomToolBar setBackgroundImage:[Unity createImageWithColor:RGBColor(235, 235, 235, 1.0f)] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    
    [_webView setOpaque:NO];
    _webView.autoresizesSubviews = YES;
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [_webView setBackgroundColor:[UIColor clearColor]];
    
    NSMutableURLRequest *request = nil;
    if ([Unity checkReachable]) {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
    } else {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:30];
    }
    
    [_webView loadRequest:request];
    [self.view makeToastActivity];
}

- (IBAction)openSafari:(id)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    }
}

- (IBAction)refresh:(id)sender
{
    [_webView stopLoading];
    
    NSMutableURLRequest *request = nil;
    if ([Unity checkReachable]) {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
    } else {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:30];
    }
    
    [_webView loadRequest:request];
    [self.view makeToastActivity];
}
#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view hideToastActivity];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.view hideToastActivity];
    [self.navigationController.view makeToast:@"网页加载失败..."];
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_webView release];
    [_url release];
    [_buttomToolBar release];
    [super dealloc];
}
@end
