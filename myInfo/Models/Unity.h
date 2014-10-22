//
//  JS+Unity.h
//  myInfo
//
//  Created by JianShaoChen on 8/9/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <Foundation/Foundation.h> 

#import "Toast+UIView.h"
#import "MobClick.h"
#import "UMFeedback.h" 
#import "CXMLDocument.h"
#import "JSNetworkEngine.h"
#import "JSTableView.h"
#import "SDURLCache.h"

#ifndef DEBUG
#undef NSLog
#define NSLog(args, ...)
#endif

#define RGBColor(Red,Green,Blue,Alpha) [UIColor colorWithRed:(Red)/255.0 green:(Green)/255.0 blue:(Blue)/255.0 alpha:(Alpha)]
#define iOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) ? YES : NO
#define iOS_8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) ? YES : NO
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define BarColor RGBColor(85, 195, 234, 1.0f)
#define BackGroundColor RGBColor(47, 125, 173, 1.0f)

#define UMKEY @"5307075256240b67dd006f63"

//html头部
#define HTML_Style @"<style>#oschina_title {color: #000000; margin-bottom: 6px; font-weight:bold;}#oschina_title img{vertical-align:middle;margin-right:6px;}#oschina_title a{color:#0D6DA8;}#oschina_outline {color: #707070; font-size: 12px;}#oschina_outline a{color:#0D6DA8;}#oschina_software{color:#808080;font-size:12px}#oschina_body img {max-width: 300px;}#oschina_body {font-size:16px;max-width:300px;line-height:24px;} #oschina_body table{max-width:300px;}#oschina_body pre { font-size:9pt;font-family:Courier New,Arial;border:1px solid #ddd;border-left:5px solid #6CE26C;background:#f6f6f6;padding:5px;}</style>"

#define HTML_Style_iPad @"<style>#oschina_title {color: #000000; margin-bottom: 6px; font-weight:bold;}#oschina_title img{vertical-align:middle;margin-right:6px;}#oschina_title a{color:#0D6DA8;}#oschina_outline {color: #707070; font-size: 12px;}#oschina_outline a{color:#0D6DA8;}#oschina_software{color:#808080;font-size:12px}#oschina_body img {max-width: 748px;}#oschina_body {font-size:16px;max-width:748px;line-height:24px;} #oschina_body table{max-width:748px;}#oschina_body pre { font-size:9pt;font-family:Courier New,Arial;border:1px solid #ddd;border-left:5px solid #6CE26C;background:#f6f6f6;padding:5px;}</style>"

//html底部
#define HTML_Bottom @"<div style='margin-bottom:50px'/>"

#define HTML_Bottom_iPad @"<div style='margin-bottom:90px'/>"

/**
 新闻
 newsAbsoluteURL 开源中国
 cnblogNewsAbsoluteURL 博客园
 newsDetailAbsoluteURL 开源中国
 cnBlogNewsDetialAbsoluteURL 博客园
 博客
 blogsAbsoluteURL 开源中国
 cnBlogArticlesAbsoluteURL 博客园
 blogsDetailAbsoluteURL 开源中国
 cnBlogArticlesDetialAbsoluteURL 博客园
 */
static NSString *newsAbsoluteURL = @"http://www.oschina.net/action/api/news_list?";
static NSString *cnblogNewsAbsoluteURL = @"http://wcf.open.cnblogs.com/news/recent/paged/";
static NSString *blogsAbsoluteURL = @"http://www.oschina.net/action/api/blog_list?";
static NSString *cnBlogArticlesAbsoluteURL = @"http://wcf.open.cnblogs.com/blog/sitehome/paged/"; 
static NSString *newsDetailAbsoluteURL = @"http://www.oschina.net/action/api/news_detail?";
static NSString *blogsDetailAbsoluteURL = @"http://www.oschina.net/action/api/blog_detail?";
static NSString *cnBlogNewsDetialAbsoluteURL = @"http://wcf.open.cnblogs.com/news/item/";
static NSString *cnBlogArticlesDetialAbsoluteURL = @"http://wcf.open.cnblogs.com/blog/post/body/";

//新闻评论
static NSString *newCommentAbsoluteURL = @"http://www.oschina.net/action/api/comment_list?";
//博客评论
static NSString *blogCommentAbsoluteURL = @"http://www.oschina.net/action/api/blogcomment_list?";
//cnblog 文章评论
static NSString *cnBlogArticlesCommentAbsoluteURL = @"http://wcf.open.cnblogs.com/blog/post/";
//cnblog 新闻评论
static NSString *cnBlogNewsCommentAbsoluteURL = @"http://wcf.open.cnblogs.com/news/item/";

//cnblog 热门新闻
static NSString *cnBlogHotNewsAbsoluteURL = @"http://wcf.open.cnblogs.com/news/hot/";
static NSString *cnBlogHourArticlesAbsoluteURL = @"http://wcf.open.cnblogs.com/blog/48HoursTopViewPosts/";
static NSString *cnBlogDayArticlesAbsoluteURL = @"http://wcf.open.cnblogs.com/blog/TenDaysTopDiggPosts/";

//搜索
static NSString *searchAbsoluteURL = @"http://www.oschina.net/action/api/search_list?";

typedef void(^getDataFeedBackBlock) (NSArray *array, NSError *error);
typedef void(^getDataFeedBackDetialBlock) (id object, NSError *error);

@interface Unity : NSObject

@property (nonatomic, copy) getDataFeedBackBlock getDataBlock;
@property (nonatomic, copy) getDataFeedBackDetialBlock getDataDetialBlock;

//UIColor 转 UIImage
+ (UIImage *)createImageWithColor: (UIColor *)color;
//检查网络是否链接
+ (BOOL)checkReachable;
//转化html格式
+ (NSString *)filterHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;
//获取数据
 
- (void)getDataWithParams:(NSDictionary *)params withBlock:(getDataFeedBackBlock)block withType:(requestType)type;
- (void)getDetialDataWithParams:(NSDictionary *)params withDetialBlock:(getDataFeedBackDetialBlock)block withType:(requestType)type;
@end
