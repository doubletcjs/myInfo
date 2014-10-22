//
//  TOActivityWXTimeLine.m
//  ITInfo
//
//  Created by JianShaoChen on 4/30/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "TOActivityWXTimeLine.h"
#import "WXApi.h"

@implementation TOActivityWXTimeLine

#pragma mark - Activity Display Properties -
- (NSString *)activityTitle
{
    return @"微信朋友圈";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"UMS_wechat_timeline_icon@2x.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    self.shareContent = [activityItems objectAtIndex:0];
    self.articlesLink = [activityItems objectAtIndex:1];
    self.endContent = [activityItems objectAtIndex:2];
}

- (void)performActivity
{
    [self openWeixinDialog:YES];
}

- (UIViewController *)activityViewController
{
    return nil;
}

- (void)openWeixinDialog:(BOOL)isTimeLine
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendMessageToWXReq *req = [[[SendMessageToWXReq alloc] init] autorelease];
        req.bText = YES;
        req.text = [NSString stringWithFormat:@"%@\n%@\n%@", _shareContent, [[NSURL URLWithString:_articlesLink] absoluteString], _endContent];
        //选择发送到朋友圈，默认值为WXSceneSession，发送到会话
        if (isTimeLine) {
            req.scene = WXSceneTimeline;
        }
        
        [WXApi sendReq:req];
    } else {
        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"" message:@"您的设备上还没有安装微信,无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alView show];
        [alView release];
        
    }
}

- (void)dealloc
{
    [_endContent release];
    [_articlesLink release];
    [_shareContent release];
    [super dealloc];
}

@end
