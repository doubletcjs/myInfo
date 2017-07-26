//
//  JSTableView.m
//  myInfo
//
//  Created by JianShaoChen on 8/14/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "JSTableView.h"
#import "MJRefresh.h"
#import "DetialViewController.h"

#import "NewsItem.h"
#import "CnblogNewsItem.h"

#import "BlogsItem.h"
#import "CnblogArticlesItem.h"

#import "CnblogCommentCell.h"
#import "CommentsCell.h"
#import "CommentsWithReferCell.h"

@interface JSTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *objectArray;
@property (assign) requestType type;
@property (assign) int currentPage;
@property (assign) int pageSize;

@end

@implementation JSTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithType:(requestType)type
{
    self = [super initWithFrame:[super frame] style:UITableViewStylePlain];
    
    _type = type;
    _objectArray = [NSMutableArray new]; 
    
    self.dataSource = self;
    self.delegate = self;
    
    _pageSize = 20;
    
    [self setupRefresh];
    return self;
}

- (id)initWithType:(requestType)type withCommentID:(NSString *)commentID
{
    self.commentID = commentID;
    
    return [self initWithType:type];
}
#pragma mark - 集成刷新控件
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.headerPullToRefreshText = @"下拉刷新";
    self.headerReleaseToRefreshText = @"松开刷新";
    self.headerRefreshingText = @"正在刷新中...";
    
    self.footerPullToRefreshText = @"上拉加载更多";
    self.footerReleaseToRefreshText = @"松开加载更多";
    self.footerRefreshingText = @"正在加载中...";
    
    [self setFooterHidden:YES];
    
    [self headerRefreshing];
}
#pragma mark - 刷新或加载
- (void)headerRefreshing
{
    _currentPage = 1;
    
    [self getData];
}

- (void)footerRefreshing
{
    _currentPage = _currentPage+1;
    
    [self getData];
}
#pragma mark - 反馈回调deleagete
- (id)getMyDelegate
{
	return _myDelegate;
}

- (void)setMyDelegate:(id)myDelegate
{
    if (_myDelegate != myDelegate) {
        _myDelegate = nil;
    }
	_myDelegate = myDelegate;
}
#pragma mark - 完成刷新
- (void)didRefreshData:(NSString *)seccuss
{
    self.tableFooterView = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_objectArray.count == 0) {
            [self setHeaderHidden:NO];
            [self setFooterHidden:YES];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, JSScreenWidth, 44)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"暂无数据";
            label.font = [UIFont systemFontOfSize:18];
            self.tableFooterView = label;
            [label release];
        } else {
            [self setHeaderHidden:NO];
            [self setFooterHidden:NO];
        }
        
        if (_currentPage == 1) {
            if ([seccuss isEqualToString:@"YES"]) {
                if ([_objectArray count] < _pageSize) {
                    [self setFooterHidden:YES];
                }
            } else {
                [self setFooterHidden:YES];
            }
        } else {
            if ([_objectArray count] < (_pageSize*_currentPage)) {
                [self setFooterHidden:YES];
            }
        }
        
        [self headerEndRefreshing];
        [self footerEndRefreshing];
        
        [self reloadData];
        
        if (_type == hotNews || _type == hotRead || _type == hotRecommend) {
            [self setHeaderHidden:NO];
            [self setFooterHidden:YES];
        }
         
        if (_type == newsComment|| _type == blogsComment|| _type == cnblogNewsComment || _type == cnblogArticlesComment) {
            if ([_myDelegate conformsToProtocol:@protocol(myTableViewDelegate)]) {
                if ([_myDelegate respondsToSelector:@selector(getCommentNumbers:)]) {
                    [self.myDelegate getCommentNumbers:[_objectArray count]];
                }
            }
        }
    });
}
#pragma mark - 请求数据
- (void)getData
{
    NSDictionary *parames = [NSDictionary dictionary];
    
    switch (_type) {
        case news:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", [NSString stringWithFormat:@"%d", _currentPage-1], [NSString stringWithFormat:@"%d", _pageSize], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"catalog", @"pageIndex", @"pageSize",
                                                           nil]];
        }
            break;
        case cnblogNews:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", _currentPage], [NSString stringWithFormat:@"%d", _pageSize], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"x", @"y", nil]];
        }
            break;
        case blogs:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"latest", [NSString stringWithFormat:@"%d", _currentPage-1], [NSString stringWithFormat:@"%d", _pageSize], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"type", @"pageIndex", @"pageSize",
                                                           nil]];
        }
            break;
        case cnblogArticles:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", _currentPage], [NSString stringWithFormat:@"%d", _pageSize], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"x", @"y", nil]];
        }
            break;
        case cnblogNewsComment:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_commentID, @"comments",[NSString stringWithFormat:@"%d", _currentPage], [NSString stringWithFormat:@"%d", _pageSize], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"a", @"b", @"c", @"d", nil]];
        }
            break;
        case cnblogArticlesComment:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_commentID, @"comments",[NSString stringWithFormat:@"%d", _currentPage], [NSString stringWithFormat:@"%d", _pageSize], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"a", @"b", @"c", @"d", nil]];
        }
            break;
        case newsComment:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", _commentID, [NSString stringWithFormat:@"%d", _currentPage-1], [NSString stringWithFormat:@"%d", _pageSize], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"catalog", @"id", @"pageIndex", @"pageSize",
                                                           nil]];
        }
            break;
        case blogsComment:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: _commentID, [NSString stringWithFormat:@"%d", _currentPage-1], [NSString stringWithFormat:@"%d", _pageSize], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"id", @"pageIndex", @"pageSize",
                                                           nil]];
        }
            break; 
            //综合新闻
            //http://www.oschina.net/action/api/news_list?catalog=2&pageIndex=0&pageSize=20
        case synthesizeNews:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"2", [NSString stringWithFormat:@"%d", _currentPage-1], [NSString stringWithFormat:@"%d", _pageSize], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"catalog", @"pageIndex", @"pageSize",
                                                           nil]];
            _type = news;
        }
            break;
            //软件更新
            //http://www.oschina.net/action/api/news_list?catalog=3&pageIndex=0&pageSize=20
        case softNews:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"3", [NSString stringWithFormat:@"%d", _currentPage-1], [NSString stringWithFormat:@"%d", _pageSize], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"catalog", @"pageIndex", @"pageSize",
                                                           nil]];
            _type = news;
        }
            break;
            //推荐博客
            //http://www.oschina.net/action/api/blog_list?type=recommend&pageIndex=0&pageSize=20
        case recommendBlogs:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"recommend", [NSString stringWithFormat:@"%d", _currentPage-1], [NSString stringWithFormat:@"%d", _pageSize], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"type", @"pageIndex", @"pageSize",
                                                           nil]];
            _type = blogs;
        }
            break;
            //热门新闻
            //http://wcf.open.cnblogs.com/news/hot/40
        case hotNews:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", (50+50*(random()%3))], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"x", nil]];
        }
            break;
            //推荐排行
            //http://wcf.open.cnblogs.com/blog/48HoursTopViewPosts/1000
        case hotRecommend:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", 2000], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"x", nil]];
        }
            break;
            //阅读排行
            //http://wcf.open.cnblogs.com/blog/TenDaysTopDiggPosts/1000
        case hotRead:
        {
            parames = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", 2000], nil]
                                                  forKeys:[NSArray arrayWithObjects:@"x", nil]];
        }
            break;
            
            
            
        default:
            break;
    }
    
    Unity *unity = [[Unity alloc] init];
    
    [unity getDataWithParams:parames withBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"error:%@", error);
            
            [self makeToast:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] duration:1.0f position:@"center"];
            [self didRefreshData:@"NO"];
        } else {
            if ([array count]) {
                if (_currentPage == 1) {
                    [_objectArray removeAllObjects];
                }
                
                [_objectArray addObjectsFromArray:array];
                
                [self didRefreshData:@"YES"];
            } else {
                [self didRefreshData:@"NO"];
            }
        }
    } withType:_type];
    [unity release]; 
}
#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_objectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellIdentifier";
    
    if (_type == cnblogNewsComment || _type == cnblogArticlesComment) {
        CnblogCommentCell *cell = (CnblogCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CnblogCommentCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        CnblogCommentItem *item = [_objectArray objectAtIndex:indexPath.row];
        
        NSString *dateString = [[item.cnblogCommentsItemDict objectForKey:item.cnblogCommentspublished] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        dateString = [[dateString componentsSeparatedByString:@"+"] firstObject];
        dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@""];
        
        cell.authorLabel.text = [item.cnblogCommentsItemDict objectForKey:item.cnblogCommentsauthorname];
        cell.dateLabel.text = dateString;
        cell.contentLabel.text = [item.cnblogCommentsItemDict objectForKey:item.cnblogCommentscontent];
        
        [cell defineCell:item];
        
        return cell;
    } else if (_type == newsComment || _type == blogsComment) {
        CommentsItem *item = [_objectArray objectAtIndex:indexPath.row];
        
        if (item.commentsrefers && [item.commentsrefers count]) {
            CommentsWithReferCell *cell = (CommentsWithReferCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentsWithReferCell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            NSString *dateString = [[item.commentsItemDict objectForKey:item.commentspubDate] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            dateString = [[dateString componentsSeparatedByString:@"+"] firstObject];
            dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@""];
            
            cell.authorLabel.text = [item.commentsItemDict objectForKey:item.commentsauthor];
            cell.dateLabel.text = dateString;
            cell.contentLabel.text = [item.commentsItemDict objectForKey:item.commentscontent];
            
            [cell defineCell:item];
            
            return cell;
        } else {
            CommentsCell *cell = (CommentsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentsCell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            NSString *dateString = [[item.commentsItemDict objectForKey:item.commentspubDate] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            dateString = [[dateString componentsSeparatedByString:@"+"] firstObject];
            dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@""];
            
            cell.authorLabel.text = [item.commentsItemDict objectForKey:item.commentsauthor];
            cell.dateLabel.text = dateString;
            cell.contentLabel.text = [item.commentsItemDict objectForKey:item.commentscontent];
            
            [cell defineCell:item];
            
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.numberOfLines = 2;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        switch (_type) {
            case news:
            {
                NewsItem *item = (NewsItem *)[_objectArray objectAtIndex:indexPath.row];
                cell.textLabel.text = [item.newsItemDict objectForKey:item.newstitle];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"发布于 %@  %@(评)", [self changeDate:[item.newsItemDict objectForKey:item.newspubDate]], [item.newsItemDict objectForKey:item.newscommentCount]];
            }
                break;
            case cnblogNews:
            case hotNews:
            {
                CnblogNewsItem *item = (CnblogNewsItem *)[_objectArray objectAtIndex:indexPath.row];
                cell.textLabel.text = [item.cnblogNewsItemDict objectForKey:item.cnblogNewstitle];
                
                NSString *dateString = [[item.cnblogNewsItemDict objectForKey:item.cnblogNewspublished] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                dateString = [[dateString componentsSeparatedByString:@"+"] firstObject];
                dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@""];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"发布于 %@  %@(评)  %@(阅)", [self changeDate:dateString], [item.cnblogNewsItemDict objectForKey:item.cnblogNewscomments], [item.cnblogNewsItemDict objectForKey:item.cnblogNewsviews]];
            }
                break;
            case blogs:
            {
                BlogsItem *item = (BlogsItem *)[_objectArray objectAtIndex:indexPath.row];
                cell.textLabel.text = [item.blogsItemDict objectForKey:item.blogstitle];
                
                NSString *string = [NSString stringWithFormat:@"%@  发布于 %@  %@(评)", [item.blogsItemDict objectForKey:item.blogsauthorname], [self changeDate:[item.blogsItemDict objectForKey:item.blogspubDate]], [item.blogsItemDict objectForKey:item.blogscommentCount]];
                cell.detailTextLabel.attributedText = [self hightLightName:[item.blogsItemDict objectForKey:item.blogsauthorname] inString:string];
            }
                break;
            case cnblogArticles:
            case hotRead:
            case hotRecommend:
            {
                CnblogArticlesItem *item = (CnblogArticlesItem *)[_objectArray objectAtIndex:indexPath.row];
                cell.textLabel.text = [item.cnblogArticlesItemDict objectForKey:item.cnblogArticlestitle];
                
                NSString *dateString = [[item.cnblogArticlesItemDict objectForKey:item.cnblogArticlespublished] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                dateString = [[dateString componentsSeparatedByString:@"+"] firstObject];
                dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@""];
                
                NSString *string = [NSString stringWithFormat:@"%@  发布于 %@  %@(评)  %@(阅)", [item.cnblogArticlesItemDict objectForKey:item.cnblogArticlesauthorname], [self changeDate:dateString], [item.cnblogArticlesItemDict objectForKey:item.cnblogArticlescomments], [item.cnblogArticlesItemDict objectForKey:item.cnblogArticlesviews]];
                cell.detailTextLabel.attributedText = [self hightLightName:[item.cnblogArticlesItemDict objectForKey:item.cnblogArticlesauthorname] inString:string];
                
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == cnblogNewsComment || _type == cnblogArticlesComment) {
        CnblogCommentItem *item = [_objectArray objectAtIndex:indexPath.row];
        return [CnblogCommentCell getCellHeight:item];
    } else if (_type == newsComment || _type == blogsComment) {
        CommentsItem *item = [_objectArray objectAtIndex:indexPath.row];
        
        if (item.commentsrefers && [item.commentsrefers count]) {
            return [CommentsWithReferCell getCellHeight:item];
        } else {
            return [CommentsCell getCellHeight:item];
        }
    } else {
        return 58;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetialViewController *detial = [[DetialViewController alloc] init];
    switch (_type) {
        case news:
        {
            detial.type = newsDetial;
            NewsItem *item = (NewsItem *)[_objectArray objectAtIndex:indexPath.row];
            detial.itemId = [[item.newsItemDict objectForKey:item.newsid] copy];
            detial.commentCount = [[item.newsItemDict objectForKey:item.newscommentCount] copy];
        }
            break;
        case blogs:
        {
            detial.type = blogsDetial;
            BlogsItem *item = (BlogsItem *)[_objectArray objectAtIndex:indexPath.row];
            detial.itemId = [[item.blogsItemDict objectForKey:item.blogsid] copy];
            detial.commentCount = [[item.blogsItemDict objectForKey:item.blogscommentCount] copy];
        }
            break;
        case cnblogNews:
        case hotNews:
        {
            detial.type = cnblogNewsDetial;
            CnblogNewsItem *item = (CnblogNewsItem *)[_objectArray objectAtIndex:indexPath.row];
            detial.itemId = [[item.cnblogNewsItemDict objectForKey:item.cnblogNewsid] copy];
            detial.commentCount = [[item.cnblogNewsItemDict objectForKey:item.cnblogNewscomments] copy];
            detial.articlesLink = [[item.cnblogNewsItemDict objectForKey:item.cnblogNewslink] copy];
        }
            break;
        case cnblogArticles:
        case hotRead:
        case hotRecommend:
        {
            detial.type = cnblogArticlesDetial;
            CnblogArticlesItem *item = (CnblogArticlesItem *)[_objectArray objectAtIndex:indexPath.row];
            detial.itemId = [[item.cnblogArticlesItemDict objectForKey:item.cnblogArticlesid] copy];
            detial.blogapp = [[item.cnblogArticlesItemDict objectForKey:item.cnblogArticlesblogapp] copy];
            detial.articlesDate = [[item.cnblogArticlesItemDict objectForKey:item.cnblogArticlespublished] copy];
            detial.articlesTitle = [[item.cnblogArticlesItemDict objectForKey:item.cnblogArticlestitle] copy];
            detial.articlesSource = [[item.cnblogArticlesItemDict objectForKey:item.cnblogArticlesauthorname] copy];
            detial.articlesLink = [[item.cnblogArticlesItemDict objectForKey:item.cnblogArticleslink] copy];
            detial.commentCount = [[item.cnblogArticlesItemDict objectForKey:item.cnblogArticlescomments] copy];
        }
            break;
            
        default:
            break;
    }
    
    if (_type != cnblogNewsComment || _type != cnblogArticlesComment || _type != newsComment || _type != blogsComment) {
        detial.hidesBottomBarWhenPushed = YES;
        [_navigationController pushViewController:detial animated:YES];
        
        [MobClick event:@"查看文章"];
    }
    
    [detial release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 获取到时间戳里的毫秒单位
- (UInt64)convertToTimeStamp:(NSDate *)date
{
    UInt64 recordTime = [date timeIntervalSince1970]*1000.0f;
    return recordTime;
}
#pragma mark - 转换时间显示
- (NSString *)changeDate:(NSString *)dateString
{
    //将传入时间转化成需要的格式
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate = [format dateFromString:dateString];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate:fromdate];
    NSDate *fromDate = [fromdate dateByAddingTimeInterval:frominterval];
    [format release];
    
    //获取当前时间
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSTimeInterval timeInterval = fabs(([self convertToTimeStamp:localeDate] - [self convertToTimeStamp:fromDate]))/1000;
    
    long temp = 0;
    NSString *result = @"";
    
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    } else if((temp = timeInterval/60) < 60) {
        result = [NSString stringWithFormat:@"%d分前", (int)temp];
    } else if((temp = temp/60) < 24) {
        result = [NSString stringWithFormat:@"%d小时前", (int)temp];
    } else if((temp = temp/24) < 30) {
        result = [NSString stringWithFormat:@"%d天前", (int)temp];
    } else if((temp = temp/30) < 12) {
        result = [NSString stringWithFormat:@"%d月前", (int)temp];
    } else {
        //temp = temp/12;
        //result = [NSString stringWithFormat:@"%d年前", (int)temp];
        
        result = [NSString stringWithFormat:@"%@", fromDate];
        result = [result stringByReplacingOccurrencesOfString:@" +0000" withString:@""];
    }
    
    return  result;
}
#pragma mark - 高亮用户名
- (NSMutableAttributedString *)hightLightName:(NSString *)name inString:(NSString *)string
{
    NSRange rangeOne = NSMakeRange(0, 0);
    if (name != nil && name.length > 0 && ![name isEqualToString:@""]) {
        rangeOne = [string rangeOfString:name];
        rangeOne.length += 1;
    }
    
    if (rangeOne.location != NSNotFound) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        if (rangeOne.location != NSNotFound) {
            [attrString setAttributes:@{NSForegroundColorAttributeName:BarColor} range:rangeOne];
        }
        
        return [attrString autorelease];
    } else {
        return [[[NSMutableAttributedString alloc] initWithString:name] autorelease];
    }
}
#pragma mark -
- (void)dealloc
{
    _myDelegate = nil;
    [_objectArray removeAllObjects];
    [_objectArray release];
    [_navigationController release];
    _navigationController = nil;
    [_commentID release];
    [super dealloc];
}

@end
