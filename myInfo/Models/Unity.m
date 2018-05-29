//
//  JS+Unity.m
//  myInfo
//
//  Created by JianShaoChen on 8/9/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "Unity.h"
#import "Reachability.h"

#import "NewsItem.h"
#import "CnblogNewsItem.h"

#import "BlogsItem.h"
#import "CnblogArticlesItem.h"

#import "BlogsDetialItem.h"
#import "NewsDetialItem.h"
#import "CnblogNewsDetialItem.h"

#import "CnblogCommentItem.h"
#import "CommentsItem.h"

#import "JSCache.h"

@implementation Unity
@synthesize getDataBlock = _getDataBlock;
@synthesize getDataDetialBlock = _getDataDetialBlock;

#pragma mark - 获取字体size
+ (CGSize)sizeOfattributedString:(NSMutableAttributedString *)attributedString
                          inSize:(CGSize)rangeSize {
    CGSize size = [attributedString boundingRectWithSize:rangeSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return size;
}

+ (NSString *)filterHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd] == NO) {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&;"]];
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    
    for (int i = 0; i < [components count]; i = i + 2) {
        [componentsToKeep addObject:[components objectAtIndex:i]];
    }
    
    html = [componentsToKeep componentsJoinedByString:@""];
    
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}
#pragma mark - UIColor 转 UIImage
+ (UIImage *)createImageWithColor: (UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - 检查网络是否链接
+(BOOL)checkReachable
{
    return [Reachability reachabilityForInternetConnection].isReachable;
}
#pragma mark - 解析开源中国新闻xml
- (void)resolveNewsXML:(CXMLDocument *)document
{
    NSMutableArray *array = [NSMutableArray array];
    
    CXMLElement *root = [document rootElement];
    NSArray *childs = [root children];
    for (CXMLElement *element in childs) {
        if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
            if ([[element name] isEqualToString:@"newslist"]) {
                for (int i = 0; i < [element childCount]; i++) {
                    NewsItem *item = [[NewsItem alloc] init];
                    
                    if ([[[element childAtIndex:i] name] isEqualToString:@"news"]) {
                        NSArray *childs = [[element childAtIndex:i] children];
                        for (CXMLElement *element in childs) {
                            if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
                                if ([[element name] isEqualToString:@"newstype"]) {
                                    //[item.newsItemDict setObject:[element stringValue] forKey:@"newstype"];
                                } else {
                                    [item.newsItemDict setObject:[Unity filterHTML:[element stringValue] trimWhiteSpace:YES] forKey:[NSString stringWithFormat:@"news%@", [element name]]];
                                }
                            }
                        }
                        
                        [array addObject:item];
                    }
                    
                    [item release];
                }
            }
        }
    }
    
    if (_getDataBlock) {
        _getDataBlock(array, nil);
    }
}
#pragma mark - 解析博客园新闻xml
- (void)resolveCnBlogNewsXML:(CXMLDocument *)document
{
    NSMutableArray *array = [NSMutableArray array];
    
    CXMLElement *root = [document rootElement];
    NSArray *books = [root children];
    for (CXMLElement *element in books) {
        if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
            if ([[element name] isEqualToString:@"entry"]) {
                CnblogNewsItem *item = [[CnblogNewsItem alloc] init];
                
                for (int i = 0; i < [element childCount]; i++) {
                    CXMLNode *node = [element childAtIndex:i];
                    if ([[node name] isEqualToString:@"summary"]) {
                        [item.cnblogNewsItemDict setObject:[Unity filterHTML:[node stringValue] trimWhiteSpace:YES] forKey:[NSString stringWithFormat:@"cnblogNews%@", [node name]]];
                    } else {
                        [item.cnblogNewsItemDict setObject:[Unity filterHTML:[node stringValue] trimWhiteSpace:YES] forKey:[NSString stringWithFormat:@"cnblogNews%@", [node name]]];
                    }
                }
                
                [array addObject:item];
                
                [item release];
            }
        }
    }
    
    if (_getDataBlock) {
        _getDataBlock(array, nil);
    }
}
#pragma mark - 解析博客xml
- (void)resolveBlogsXML:(CXMLDocument *)document
{
    NSMutableArray *array = [NSMutableArray array];
    
    CXMLElement *root = [document rootElement];
    NSArray *childs = [root children];
    for (CXMLElement *element in childs) {
        if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
            if ([[element name] isEqualToString:@"blogs"]) {
                for (int i = 0; i < [element childCount]; i++) {
                    BlogsItem *item = [[BlogsItem alloc] init];
                    
                    if ([[[element childAtIndex:i] name] isEqualToString:@"blog"]) {
                        NSArray *childs = [[element childAtIndex:i] children];
                        for (CXMLElement *element in childs) {
                            if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
                                [item.blogsItemDict setObject:[element stringValue] forKey:[NSString stringWithFormat:@"blogs%@", [element name]]];
                            }
                        }
                        
                        [array addObject:item];
                    }
                    
                    [item release];
                }
            }
        }
    }
    
    if (_getDataBlock) {
        _getDataBlock(array, nil);
    }
}
#pragma mark - 解析博客园文章xml
- (void)resolveCnBlogArticlesXML:(CXMLDocument *)document
{
    NSMutableArray *array = [NSMutableArray array];
    
    CXMLElement *root = [document rootElement];
    NSArray *books = [root children];
    for (CXMLElement *element in books) {
        if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
            if ([[element name] isEqualToString:@"entry"]) {
                CnblogArticlesItem *item = [[CnblogArticlesItem alloc] init];
                
                for (int i = 0; i < [element childCount]; i++) {
                    CXMLNode *node = [element childAtIndex:i];
                    if ([[node name] isEqualToString:@"author"]) {
                        for (CXMLElement *authorElement in [node children]) {
                            if ([authorElement isKindOfClass:NSClassFromString(@"CXMLElement")]) {
                                [item.cnblogArticlesItemDict setObject:[authorElement stringValue] forKey:[NSString stringWithFormat:@"cnblogArticlesauthor%@", [authorElement name]]];
                            }
                        }
                    } else {
                        if ([[node name] isEqualToString:@"summary"]) {
                            [item.cnblogArticlesItemDict setObject:[Unity filterHTML:[node stringValue] trimWhiteSpace:YES] forKey:[NSString stringWithFormat:@"cnblogArticles%@", [node name]]];
                        } else {
                            [item.cnblogArticlesItemDict setObject:[node stringValue] forKey:[NSString stringWithFormat:@"cnblogArticles%@", [node name]]];
                        }
                    }
                }
                
                [array addObject:item];
            }
        }
    }
    
    if (_getDataBlock) {
        _getDataBlock(array, nil);
    }
}
#pragma mark - 解析新闻详情xml
- (void)resolveNewsDetialXML:(CXMLDocument *)document
{
    NewsDetialItem *item = [[NewsDetialItem alloc] init];
    
    CXMLElement *root = [document rootElement];
    NSArray *childs = [root children];
    for (CXMLElement *element in childs) {
        if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
            if ([[element name] isEqualToString:@"news"]) {
                for (int i = 0; i < [element childCount]; i++) {
                    if ([[element childAtIndex:i] isKindOfClass:NSClassFromString(@"CXMLElement")]) {
                        CXMLNode *node = [element childAtIndex:i];
                        
                        if ([[node name] isEqualToString:@"relativies"]) {
                            for (CXMLElement *relativiesElement in [node children]) {
                                NSMutableDictionary *relativeDict = [NSMutableDictionary dictionary];
                                
                                if ([relativiesElement isKindOfClass:NSClassFromString(@"CXMLElement")]) {
                                    if ([[relativiesElement name] isEqualToString:@"relative"]) {
                                        for (int j = 0; j < [relativiesElement childCount]; j++) {
                                            if ([[relativiesElement childAtIndex:j] isKindOfClass:NSClassFromString(@"CXMLElement")]) {
                                                if ([[[relativiesElement childAtIndex:j] name] isEqualToString:@"rurl"]) {
                                                    [relativeDict setObject:[[relativiesElement childAtIndex:j] stringValue] forKey:@"url"];
                                                } else if ([[[relativiesElement childAtIndex:j] name] isEqualToString:@"rtitle"]) {
                                                    [relativeDict setObject:[[relativiesElement childAtIndex:j] stringValue] forKey:@"title"];
                                                }
                                            }
                                        }
                                        
                                        [item.newsDetialRelativies addObject:relativeDict];
                                    }
                                }
                            }
                        } else {
                            [item.newsDetialItemDict setObject:[node stringValue] forKey:[NSString stringWithFormat:@"newsDetial%@", [node name]]];
                        }
                    }
                }
            }
        }
    }
    
    if (_getDataDetialBlock) {
        _getDataDetialBlock(item, nil);
    }
    
    [item release];
}
#pragma mark - 解析博客详情xml
- (void)resolveBlogsDetialXML:(CXMLDocument *)document
{
    BlogsDetialItem *item = [[BlogsDetialItem alloc] init];
    
    CXMLElement *root = [document rootElement];
    NSArray *childs = [root children];
    for (CXMLElement *element in childs) {
        if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
            if ([[element name] isEqualToString:@"blog"]) {
                for (int i = 0; i < [element childCount]; i++) {
                    if ([[element childAtIndex:i] isKindOfClass:NSClassFromString(@"CXMLElement")]) {
                        CXMLNode *node = [element childAtIndex:i];
                        [item.blogsDetialItemDict setObject:[node stringValue] forKey:[NSString stringWithFormat:@"blogsDetial%@", [node name]]];
                    }
                }
            }
        }
    }
    
    if (_getDataDetialBlock) {
        _getDataDetialBlock(item, nil);
    }
    
    [item release];
}
#pragma mark - 解析博客园新闻详情xml
- (void)resolveCnblogNewsDetialXML:(CXMLDocument *)document
{
    CnblogNewsDetialItem *item = [[CnblogNewsDetialItem alloc] init];
    
    CXMLElement *root = [document rootElement];
    NSArray *childs = [root children];
    for (CXMLElement *element in childs) {
        if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
            [item.cnblogNewsDetialItemDict setObject:[element stringValue] forKey:[NSString stringWithFormat:@"cnblogNewsDetial%@", [element name]]];
        }
    }
    
    if (_getDataDetialBlock) {
        _getDataDetialBlock(item, nil);
    }
    
    [item release];
}
#pragma mark - 解析博客园文章详情xml
- (void)resolveCnblogArticlesDetialXML:(CXMLDocument *)document
{
    NSString *content = @"";
    CXMLElement *root = [document rootElement];
    NSArray *childs = [root children];
    for (CXMLElement *element in childs) {
        content = [element stringValue];
    }
    
    if (_getDataDetialBlock) {
        _getDataDetialBlock(content, nil);
    }
}
#pragma mark - 解析博客园评论xml
- (void)resolveCnBlogCommentsXML:(CXMLDocument *)document
{
    NSMutableArray *array = [NSMutableArray array];
    
    CXMLElement *root = [document rootElement];
    NSArray *books = [root children];
    for (CXMLElement *element in books) {
        if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
            if ([[element name] isEqualToString:@"entry"]) {
                CnblogCommentItem *item = [[CnblogCommentItem alloc] init];
                
                for (int i = 0; i < [element childCount]; i++) {
                    CXMLNode *node = [element childAtIndex:i];
                    
                    if ([[node name] isEqualToString:@"author"]) {
                        for (CXMLElement *authorElement in [node children]) {
                            if ([authorElement isKindOfClass:NSClassFromString(@"CXMLElement")]) {
                                [item.cnblogCommentsItemDict setObject:[authorElement stringValue] forKey:[NSString stringWithFormat:@"cnblogCommentsauthor%@", [authorElement name]]];
                            }
                        }
                    } else {
                        if ([[node name] isEqualToString:@"content"]) {
                            [item.cnblogCommentsItemDict setObject:[Unity filterHTML:[node stringValue] trimWhiteSpace:YES] forKey:[NSString stringWithFormat:@"cnblogComments%@", [node name]]];
                        } else {
                            [item.cnblogCommentsItemDict setObject:[node stringValue] forKey:[NSString stringWithFormat:@"cnblogComments%@", [node name]]];
                        }
                    }
                }
                
                [array addObject:item];
                
                [item release];
            }
        }
    }
    
    if (_getDataBlock) {
        _getDataBlock(array, nil);
    }
}
#pragma mark - 解析评论xml
- (void)resolveCommentsXML:(CXMLDocument *)document
{
    NSMutableArray *array = [NSMutableArray array];
    
    CXMLElement *root = [document rootElement];
    NSArray *books = [root children];
    for (CXMLElement *element in books) {
        if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
            if ([[element name] isEqualToString:@"comments"]) {
                for (int i = 0; i < [element childCount]; i++) {
                    if ([[element childAtIndex:i] isKindOfClass:NSClassFromString(@"CXMLElement")]) {
                        CXMLElement *commentElement = (CXMLElement *)[element childAtIndex:i];
                        
                        if ([[commentElement name] isEqualToString:@"comment"]) {
                            CommentsItem *item = [[CommentsItem alloc] init];
                            
                            for (int j = 0; j < [commentElement childCount]; j++) {
                                if ([[commentElement childAtIndex:j] isKindOfClass:NSClassFromString(@"CXMLElement")]) {
                                    CXMLNode *node = [commentElement childAtIndex:j];
                                    
                                    if ([[node name] isEqualToString:@"refers"]) {
                                        for (CXMLElement *refersCommentElement in [node children]) {
                                            if ([[refersCommentElement name] isEqualToString:@"refer"]) {
                                                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                                
                                                for (int k = 0; k < [refersCommentElement childCount]; k++) {
                                                    if ([[refersCommentElement childAtIndex:k] isKindOfClass:NSClassFromString(@"CXMLElement")]) {
                                                        CXMLNode *refernode = [refersCommentElement childAtIndex:k];
                                                        [dict setObject:[refernode stringValue] forKey:[NSString stringWithFormat:@"comments%@", [refernode name]]];
                                                    }
                                                }
                                                
                                                [item.commentsrefers addObject:dict];
                                            }
                                        }
                                    } else {
                                        if ([[node name] isEqualToString:@"content"]) {
                                            [item.commentsItemDict setObject:[Unity filterHTML:[node stringValue] trimWhiteSpace:YES] forKey:[NSString stringWithFormat:@"comments%@", [node name]]];
                                        } else {
                                            [item.commentsItemDict setObject:[node stringValue] forKey:[NSString stringWithFormat:@"comments%@", [node name]]];
                                        }
                                    }
                                }
                            }
                            
                            [array addObject:item];
                        }
                    }
                }
            }
        }
    }
    
    if (_getDataBlock) {
        _getDataBlock(array, nil);
    }
}
#pragma mark - 获取数据
- (void)getDetialDataWithParams:(NSDictionary *)params withDetialBlock:(getDataFeedBackDetialBlock)block withType:(requestType)type
{
    self.getDataDetialBlock = block;
    
    NSString *urlPath = nil;
    switch (type) {
        case newsDetial:
            urlPath = newsDetailAbsoluteURL;
            break;
        case cnblogNewsDetial:
            urlPath = cnBlogNewsDetialAbsoluteURL;
            break;
        case blogsDetial:
            urlPath = blogsDetailAbsoluteURL;
            break;
        case cnblogArticlesDetial:
            urlPath = cnBlogArticlesDetialAbsoluteURL;
            break;
        default:
            urlPath = newsDetailAbsoluteURL;
            break;
    }
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:urlPath];
    for (NSString *key in params) {
        NSString *value = [params objectForKey:key];
        NSInteger i = [[params allKeys] indexOfObject:key];
        if (i > 0) {
            [urlString appendFormat:@"%@%@=%@", @"&", key, value];
        } else {
            [urlString appendFormat:@"%@=%@", key, value];
        }
        value = nil;
    }
    
    NSString *key = [self MD5Hash:urlString]; 
    
    if ([Unity checkReachable]) {
        JSNetworkEngine *networkEngine = [[JSNetworkEngine alloc] init];
        
        [networkEngine startNetworkEngine:urlPath withMethod:@"GET" params:params withHandle:^(NSMutableData *resultData, NSError *error) {
            if (error) {
                NSLog(@"错误读本地");
                [self requestLocalData:key requestType:type];
            } else {
                if (resultData) {
                    [JSCache setObject:resultData forKey:key];
                    [self responseXML:type withData:resultData];
                } else {
                    NSLog(@"错误读本地");
                    [self requestLocalData:key requestType:type];
                }
            };
        }];
        [networkEngine release];
    } else {
        NSLog(@"离线读本地");
        [self requestLocalData:key requestType:type];
    }
}

- (void)getDataWithParams:(NSDictionary *)params withBlock:(getDataFeedBackBlock)block withType:(requestType)type
{
    self.getDataBlock = block;
    NSString *urlPath = nil;
    switch (type) {
        case news:
            urlPath = newsAbsoluteURL;
            break;
        case cnblogNews:
            urlPath = cnblogNewsAbsoluteURL;
            break;
        case blogs:
            urlPath = blogsAbsoluteURL;
            break;
        case cnblogArticles:
            urlPath = cnBlogArticlesAbsoluteURL;
            break;
        case cnblogNewsComment:
            urlPath = cnBlogNewsCommentAbsoluteURL;
            break;
        case cnblogArticlesComment:
            urlPath = cnBlogArticlesCommentAbsoluteURL;
            break;
        case newsComment:
            urlPath = newCommentAbsoluteURL;
            break;
        case blogsComment:
            urlPath = blogCommentAbsoluteURL;
            break;
        case hotNews:
            urlPath = cnBlogHotNewsAbsoluteURL;
            break;
        case hotRecommend:
            urlPath = cnBlogHourArticlesAbsoluteURL;
            break;
        case hotRead:
            urlPath = cnBlogDayArticlesAbsoluteURL;
            break;
            
        default:
            urlPath = newsAbsoluteURL;
            break;
    } 
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:urlPath];
    for (NSString *key in params) {
        NSString *value = [params objectForKey:key];
        NSInteger i = [[params allKeys] indexOfObject:key];
        if (i > 0) {
            [urlString appendFormat:@"%@%@=%@", @"&", key, value];
        } else {
            [urlString appendFormat:@"%@=%@", key, value];
        }
        value = nil;
    }
    
    NSString *key = [self MD5Hash:urlString];
    
    if ([Unity checkReachable]) {
        JSNetworkEngine *networkEngine = [[JSNetworkEngine alloc] init];
        
        [networkEngine startNetworkEngine:urlPath withMethod:@"GET" params:params withHandle:^(NSMutableData *resultData, NSError *error) {
            if (error) {
                NSLog(@"错误读本地");
                [self requestLocalData:key requestType:type];
            } else {
                if (resultData) {
                    [JSCache setObject:resultData forKey:key];
                    [self responseXML:type withData:resultData];
                } else {
                    NSLog(@"错误读本地");
                    [self requestLocalData:key requestType:type];
                }
            };
        }];
        [networkEngine release];
    } else {
        NSLog(@"离线读本地");
        [self requestLocalData:key requestType:type];
    }
}
#pragma mark - 解析xml并返回
- (void)responseXML:(requestType)type withData:(NSMutableData *)resultData
{
    switch (type) {
        case news:
            [self resolveNewsXML:[JSNetworkEngine responseXML:resultData]];
            break;
        case cnblogNews:
        case hotNews:
            [self resolveCnBlogNewsXML:[JSNetworkEngine responseXML:resultData]];
            break;
        case blogs:
            [self resolveBlogsXML:[JSNetworkEngine responseXML:resultData]];
            break;
        case cnblogArticles:
        case hotRecommend:
        case hotRead:
            [self resolveCnBlogArticlesXML:[JSNetworkEngine responseXML:resultData]];
            break;
        case cnblogNewsComment:
        {
            [self resolveCnBlogCommentsXML:[JSNetworkEngine responseXML:resultData]];
        }
            break;
        case cnblogArticlesComment:
        {
            [self resolveCnBlogCommentsXML:[JSNetworkEngine responseXML:resultData]];
        }
            break;
        case newsComment:
        case blogsComment:
        {
            [self resolveCommentsXML:[JSNetworkEngine responseXML:resultData]];
        }
            break;
        case newsDetial:
            [self resolveNewsDetialXML:[JSNetworkEngine responseXML:resultData]];
            break;
        case cnblogNewsDetial:
            [self resolveCnblogNewsDetialXML:[JSNetworkEngine responseXML:resultData]];
            break;
        case blogsDetial:
            [self resolveBlogsDetialXML:[JSNetworkEngine responseXML:resultData]];
            break;
        case cnblogArticlesDetial:
            [self resolveCnblogArticlesDetialXML:[JSNetworkEngine responseXML:resultData]];
            break;
            
        default:
            break;
    }
}
#pragma mark - md5加密
- (NSString *)MD5Hash:(NSString *)string
{
	const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
#pragma mark - 读取本地数据
- (BOOL)requestLocalData:(NSString *)key requestType:(requestType)type
{
    NSMutableData *resultData = [JSCache objectForKey:key];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"数据获取失败！" forKey:NSLocalizedDescriptionKey];
    NSError *aError = [NSError errorWithDomain:@"未知错误" code:440 userInfo:userInfo];
    
    if (resultData) {
        [self responseXML:type withData:resultData];
        
        aError = nil;
        userInfo = nil;
        resultData = nil;
        return YES;
    } else {
        if (self.getDataBlock) {
            self.getDataBlock(nil, aError);
        }
        
        if (self.getDataDetialBlock) {
            self.getDataDetialBlock(nil, aError);
        }
        
        aError = nil;
        userInfo = nil;
        resultData = nil;
        return NO;
    }
}
#pragma mark -
- (void)dealloc
{
    Block_release(_getDataBlock);
    Block_release(_getDataDetialBlock);
    [super dealloc];
}
@end
