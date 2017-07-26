//
//  DetialViewController.m
//  myInfo
//
//  Created by JianShaoChen on 8/3/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "DetialViewController.h"
#import "NewsDetialItem.h"
#import "BlogsDetialItem.h"
#import "CnblogNewsDetialItem.h"
#import "SimpleWebViewController.h"
#import "GDTMobBannerView.h"  

@interface DetialViewController () <UIWebViewDelegate, UIActionSheetDelegate, myTableViewDelegate, UIScrollViewDelegate, GDTMobBannerViewDelegate>
{
    GDTMobBannerView *_bannerView;
}
@property (copy, nonatomic) NSString *shareContent;

@end

@implementation DetialViewController

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
    // Do any additional setup after loading the view.
    [_webView setOpaque:NO];
    _webView.delegate = self;
    _webView.autoresizesSubviews = YES;
    [_webView setBackgroundColor:[UIColor clearColor]];
    [self.view makeToastActivity];
    
    NSDictionary *parames = [NSDictionary dictionary];
    
    requestType commentType = newsComment;
    switch (_type) {
        case newsDetial:
        {
            self.title = @"新闻详情";
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_itemId, nil]
                                                  forKeys:[NSArray arrayWithObjects:@"id", nil]];
            commentType = newsComment;
        }
            break;
        case cnblogNewsDetial:
        {
            self.title = @"新闻详情";
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_itemId, nil]
                                                  forKeys:[NSArray arrayWithObjects:@"x", nil]];
            commentType = cnblogNewsComment;
        }
            break;
        case blogsDetial:
        {
            self.title = @"博客详情";
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_itemId, nil]
                                                  forKeys:[NSArray arrayWithObjects:@"id", nil]];
            commentType = blogsComment;
        }
            break;
        case cnblogArticlesDetial:
        {
            self.title = @"文章详情";
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_itemId, nil]
                                                  forKeys:[NSArray arrayWithObjects:@"x", nil]];
            commentType = cnblogArticlesComment;
        }
            break;
            
        default:
            break;
    }
    
    self.collectionId = _itemId;
    self.collectionType = [NSString stringWithFormat:@"%d", _type];
    if ([self isCollection]) {
        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:[self collectionDirectory]];
        plistDict = [plistDict objectForKey:[NSString stringWithFormat:@"%@_%@", _collectionType, _collectionId]];
        self.collectionHtmlContent = [plistDict objectForKey:@"htmlContent"];
        plistDict = nil;
    }
    
    self.articlesLink = @"https://itunes.apple.com/cn/app/bo-ke-xin-wen/id827116087?l=en&mt=8";
    if (_collectionHtmlContent) {
        [_webView loadHTMLString:_collectionHtmlContent baseURL:nil];
        [self.view hideToastActivity];
    } else {
        Unity *unity = [[Unity alloc] init];
        
        [unity getDetialDataWithParams:parames withDetialBlock:^(id object, NSError *error) {
            if (error) {
                NSLog(@"error:%@", error);
                
                [self.view makeToast:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] duration:1.0f position:@"center"];
                [self.view hideToastActivity];
            } else {
                if (object) {
                    NSString *author_str = @"";
                    NSString *software = @"";
                    NSString *html = @"";
                    NSString *style = HTML_Style;
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                        style = HTML_Style_iPad;
                    }
                    NSString *buttomStyle = HTML_Bottom;
                    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                        style = HTML_Bottom_iPad;
                    }
                    
                    switch (_type) {
                        case newsDetial:
                        {
                            NewsDetialItem *item = (NewsDetialItem *)object;
                            
                            author_str = [NSString stringWithFormat:@"<a href='http://my.oschina.net/u/%@'>%@</a> 发布于 %@", [item.newsDetialItemDict objectForKey:item.newsDetialid], [item.newsDetialItemDict objectForKey:item.newsDetialauthor], [item.newsDetialItemDict objectForKey:item.newsDetialpubDate]];
                            
                            if ([[item.newsDetialItemDict objectForKey:item.newsDetialsoftwarename] isEqualToString:@""] == NO) {
                                software = [NSString stringWithFormat:@"<div id='oschina_software' style='margin-top:8px;color:#FF0000;font-size:14px;font-weight:bold'>更多关于:&nbsp;<a href='%@'>%@</a>&nbsp;的详细信息</div>",[item.newsDetialItemDict objectForKey:item.newsDetialsoftwarelink], [item.newsDetialItemDict objectForKey:item.newsDetialsoftwarename]];
                            }
                            
                            html = [NSString stringWithFormat:@"<body>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@%@%@</body>",style, [item.newsDetialItemDict objectForKey:item.newsDetialtitle], author_str, [item.newsDetialItemDict objectForKey:item.newsDetialbody], software, [self generateRelativeNewsString:item.newsDetialRelativies], buttomStyle];
                            
                            html = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\" /><meta http-equiv=\"Content-Type\" content=\"textml; charset=UTF-8\" /><style><center>img\{width:100%%;}</center></style></head><body>%@</body><ml>", html];
                            
                            self.commentCount = [item.newsDetialItemDict objectForKey:item.newsDetialcommentCount];
                            self.shareContent = [NSString stringWithFormat:@"[%@]:", [item.newsDetialItemDict objectForKey:item.newsDetialtitle]];
                            self.collectionTitle = [item.newsDetialItemDict objectForKey:item.newsDetialtitle];
                            self.articlesLink = [item.newsDetialItemDict objectForKey:item.newsDetialurl];
                        }
                            break;
                        case blogsDetial:
                        {
                            BlogsDetialItem *item = (BlogsDetialItem *)object;
                            
                            author_str = [NSString stringWithFormat:@"<a href='http://my.oschina.net/u/%@'>%@</a> 发布于 %@", [item.blogsDetialItemDict objectForKey:item.blogsDetialid], [item.blogsDetialItemDict objectForKey:item.blogsDetialauthor], [item.blogsDetialItemDict objectForKey:item.blogsDetialpubDate]];
                            html = [NSString stringWithFormat:@"<body>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@</body>", style, [item.blogsDetialItemDict objectForKey:item.blogsDetialtitle], author_str, [item.blogsDetialItemDict objectForKey:item.blogsDetialbody], buttomStyle];
                            
                            self.commentCount = [item.blogsDetialItemDict objectForKey:item.blogsDetialcommentCount];
                            self.shareContent = [NSString stringWithFormat:@"[%@]:", [item.blogsDetialItemDict objectForKey:item.blogsDetialtitle]];
                            self.collectionTitle = [item.blogsDetialItemDict objectForKey:item.blogsDetialtitle];
                            self.articlesLink = [item.blogsDetialItemDict objectForKey:item.blogsDetialurl];
                        }
                            break;
                        case cnblogNewsDetial:
                        {
                            CnblogNewsDetialItem *item = (CnblogNewsDetialItem *)object;
                            
                            NSString *dateString = [[item.cnblogNewsDetialItemDict objectForKey:item.cnblogNewsDetialSubmitDate] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                            dateString = [[dateString componentsSeparatedByString:@"+"] firstObject];
                            dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@""];
                            
                            author_str = [NSString stringWithFormat:@"<a href='cnblogNewsDetial_%@'>%@</a> 发布于 %@", [item.cnblogNewsDetialItemDict objectForKey:item.cnblogNewsDetialSourceName], [item.cnblogNewsDetialItemDict objectForKey:item.cnblogNewsDetialSourceName], dateString];
                            html = [NSString stringWithFormat:@"<body>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@</body>", style, [item.cnblogNewsDetialItemDict objectForKey:item.cnblogNewsDetialTitle], author_str, [item.cnblogNewsDetialItemDict objectForKey:item.cnblogNewsDetialContent], buttomStyle];
                             
                            self.commentCount = [item.cnblogNewsDetialItemDict objectForKey:item.cnblogNewsDetialCommentCount];
                            self.shareContent = [NSString stringWithFormat:@"[%@]:", [item.cnblogNewsDetialItemDict objectForKey:item.cnblogNewsDetialTitle]];
                            self.collectionTitle = [item.cnblogNewsDetialItemDict objectForKey:item.cnblogNewsDetialTitle];
                        }
                            break;
                        case cnblogArticlesDetial:
                        {
                            NSString *content = (NSString *)object;
                            
                            NSString *dateString = [_articlesDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                            dateString = [[dateString componentsSeparatedByString:@"+"] firstObject];
                            dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@""];
                            
                            author_str = [NSString stringWithFormat:@"<a href='cnblogArticlesDetial_%@'>%@</a> 发布于 %@", _blogapp, _articlesSource, dateString];
                            html = [NSString stringWithFormat:@"<body>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@</body>", style, _articlesTitle, author_str, content, buttomStyle];
                            
                            self.shareContent = [NSString stringWithFormat:@"[%@]:", _articlesTitle];
                            self.collectionTitle = _articlesTitle;
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                    self.collectionId = _itemId;
                    self.collectionHtmlContent = html;
                    self.collectionType = [NSString stringWithFormat:@"%d", _type];
                    
                    [_webView loadHTMLString:html baseURL:nil];
                    [self.view hideToastActivity];
                } else {
                    [self.view makeToast:@"内容加载失败..." duration:1.0f position:@"center"];
                    [self.view hideToastActivity];
                }
            }
        } withType:_type];
        [unity release];
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _detialScrollView.contentSize = CGSizeMake(width*2, 0);
    _detialScrollView.showsHorizontalScrollIndicator = NO;
    _detialScrollView.showsVerticalScrollIndicator = NO;
    _detialScrollView.scrollEnabled = YES;
    _detialScrollView.pagingEnabled = YES;
    _detialScrollView.bounces = NO;
    _detialScrollView.delegate = self;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 60, 40);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    button = nil;
    
    JSTableView *tableView = [[JSTableView alloc] initWithType:commentType withCommentID:_itemId];
    tableView.myDelegate = self;
    tableView.frame = CGRectMake(width, 0, _detialScrollView.frame.size.width, _detialScrollView.frame.size.height);
    tableView.autoresizingMask = _detialScrollView.autoresizingMask;
    tableView.navigationController = self.navigationController;
    [_detialScrollView addSubview:tableView];
    [tableView release];
    
    CGFloat hight = 50;
    _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-hight-64, JSScreenWidth, hight)
                                                   appkey:@"1102537476"
                                              placementId:@"9050009021315348"];
    _bannerView.delegate = self;
    _bannerView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, _bannerView.center.y);
    _bannerView.currentViewController = self;
    _bannerView.interval = 30;
    _bannerView.isGpsOn = YES;
    _bannerView.showCloseBtn = NO;
    _bannerView.isAnimationOn = YES;
    [_detialScrollView insertSubview:_bannerView aboveSubview:_webView];
    [_bannerView loadAdAndShow];
}
#pragma mark - 获取评论数
- (void)getCommentNumbers:(NSInteger)count
{
    self.commentCount = [NSString stringWithFormat:@"%ld", (long)count];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x/scrollView.frame.size.width == 1) {
        [MobClick event:@"查看评论"];
    }
}
#pragma mark - 更多
- (void)showMore
{
    if ([_commentCount length] < 1) {
        _commentCount = @"0";
    }
    
    if ([self isCollection]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更多" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"评论(%@)", _commentCount], @"分享", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.navigationController.view];
        [actionSheet release];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更多" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"评论(%@)", _commentCount], @"分享", @"收藏", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.navigationController.view];
        [actionSheet release];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:[NSString stringWithFormat:@"评论(%@)", _commentCount]]) {
        [_detialScrollView setContentOffset:CGPointMake(_detialScrollView.frame.size.width, 0) animated:YES];
        [MobClick event:@"查看评论"];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"分享"]) {
        [MobClick event:@"分享"];
        
        NSArray *activityItems = [[NSArray alloc] initWithObjects:
                                  _shareContent,
                                  _articlesLink,
                                  [self capture],
                                  @"@博客新闻",
                                  [NSURL URLWithString:_articlesLink], nil];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[[UIActivity new]]];
        if (iOS_7) {
            activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,
                                                             UIActivityTypePostToTwitter,
                                                             UIActivityTypePrint,
                                                             UIActivityTypeCopyToPasteboard,
                                                             UIActivityTypeAssignToContact,
                                                             UIActivityTypeSaveToCameraRoll,
                                                             UIActivityTypeAddToReadingList,
                                                             UIActivityTypePostToFlickr,
                                                             UIActivityTypePostToVimeo,
                                                             UIActivityTypeAirDrop];
        } else {
            activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,
                                                             UIActivityTypePostToTwitter,
                                                             UIActivityTypePrint,
                                                             UIActivityTypeCopyToPasteboard,
                                                             UIActivityTypeAssignToContact,
                                                             UIActivityTypeSaveToCameraRoll];
        }
        
        if (iOS_8 && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
                UIPopoverPresentationController *presentationController = [activityViewController popoverPresentationController];
                presentationController.sourceView = self.navigationController.view;
                presentationController.sourceRect = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                presentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self presentViewController:activityViewController animated:YES completion:nil];
                });
            }
        } else {
           [self presentViewController:activityViewController animated:YES completion:nil];
        }
         
        [activityItems release];
        [activityViewController release];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"收藏"]) {
        [self collection];
    }
}
#pragma mark - 截屏
- (UIImage *)capture
{
    CGFloat hight = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 90 : 50;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-hight), self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
#pragma mark - 收藏
- (BOOL)isCollection
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[self collectionDirectory]];
    if (dict) {
        NSDictionary *collectionDict = [dict objectForKey:[NSString stringWithFormat:@"%@_%@", _collectionType, _collectionId]];
        if (collectionDict) {
            return YES;
        }
    }
    
    dict = nil;
    return NO;
}

- (NSString *)collectionDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@".Collection"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *plistPath = [path stringByAppendingPathComponent:@"collection.plist"];
	return plistPath;
}

- (void)collection
{
    if ([_collectionHtmlContent length] < 1) {
        _collectionHtmlContent = @"";
    }
    if ([_collectionId length] < 1) {
        _collectionId = @"";
    }
    if ([_collectionTitle length] < 1) {
        _collectionTitle = @"";
    }
    if ([_collectionType length] < 1) {
        _collectionType = @"";
    }
    
    [self.view makeToastActivity];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_collectionId forKey:@"id"];
        [dict setObject:_collectionType forKey:@"type"];
        [dict setObject:_collectionTitle forKey:@"title"];
        [dict setObject:_collectionHtmlContent forKey:@"htmlContent"];
        
        NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:[self collectionDirectory]];
        
        if (!plistDict) {
            plistDict = [NSMutableDictionary dictionary];
        }
        
        [plistDict setObject:dict forKey:[NSString stringWithFormat:@"%@_%@", _collectionType, _collectionId]];
        [plistDict writeToFile:[self collectionDirectory] atomically:YES];
        
        dict = nil;
        plistDict = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
        });
    });
}
#pragma mark - 获取推荐文章
- (NSString *)generateRelativeNewsString:(NSArray *)array
{
    if (array == nil || [array count] == 0) {
        return @"";
    }
    
    NSString *middle = @"";
    for (NSDictionary *dict in array) {
        middle = [NSString stringWithFormat:@"%@<a href=%@ style='text-decoration:none'>%@</a><p/>",middle, [dict objectForKey:@"url"], [dict objectForKey:@"title"]];
    }
    
    return [NSString stringWithFormat:@"<hr/>相关文章<div style='font-size:14px'><p/>%@</div>", middle];
}
#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth,oldheight;"
     "var maxwidth=300;" //缩放系数
     "var maxheight=300;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "oldheight = myimg.height;"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "if(myimg.height > maxheight){"
     "myimg.height = maxheight}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString *url = [request.URL absoluteString]; 
        if ([url hasPrefix:@"http"]) {
            SimpleWebViewController *web = [[SimpleWebViewController alloc] init];
            web.url = url;
            [self.navigationController pushViewController:web animated:YES];
            [web release];
            
            [MobClick event:@"浏览器"];
        }
        return NO;
    }
    return YES;
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _bannerView.delegate = nil; 
    [_bannerView release];
    _bannerView = nil;
    NSLog(@"detial dealloc");
    [_blogapp release];
    [_articlesTitle release];
    [_articlesDate release];
    [_articlesSource release];
    [_articlesLink release];
    [_webView release];
    [_itemId release];
    [_commentCount release];
    [_shareContent release];
    [_detialScrollView release];
    [_collectionType release];
    [_collectionId release];
    [_collectionTitle release];
    [_collectionHtmlContent release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setDetialScrollView:nil];
    [super viewDidUnload];
}
@end
