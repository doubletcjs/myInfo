//
//  UINavigationController+JS.m
//  ITInfo
//
//  Created by JianShaoChen on 10/8/13.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "UINavigationController+JS.h"
#import <MessageUI/MessageUI.h>

@implementation UINavigationController (JS)

#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationBar setBackgroundImage:[Unity createImageWithColor:BarColor] forBarMetrics:UIBarMetricsDefault];
    
    if (![self isKindOfClass:[MFMailComposeViewController class]]) {
        if (iOS_7) {
            self.navigationBar.tintColor = [UIColor whiteColor];
        } else {
            self.navigationBar.tintColor = [UIColor blackColor];
        }
    }
    
    UIFont *titleFont = [UIFont systemFontOfSize:18];
    UIColor *titleColor = [UIColor blackColor];
    UIColor *titleShadowColor = [UIColor clearColor];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:titleFont forKey:NSFontAttributeName];
    [dict setObject:titleColor forKey:NSForegroundColorAttributeName];
    [dict setObject:titleShadowColor forKey:UITextAttributeTextShadowColor];
    self.navigationBar.titleTextAttributes = dict;
    [self.navigationBar setBackgroundColor:[UIColor clearColor]];
    dict = nil;
    
    [self setHiddenHairLine:YES];
}

- (void)setHiddenHairLine:(BOOL)hidden
{
    if (hidden == YES) {
        for (UIView *view in self.navigationBar.subviews) {
            for (UIView *subView in view.subviews) {
                if ([subView isKindOfClass:[UIImageView class]] && subView.frame.size.height <= 4 ) {
                    [subView setHidden:hidden];
                }
            }
        }
    }
}
#pragma mark - 返回
- (void)goBack
{
    [self popViewControllerAnimated:YES];
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
