//
//  ThreeViewController.m
//  myInfo
//
//  Created by JianShaoChen on 8/3/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchItem.h"
#import "DetialViewController.h"
#import "NewsItem.h"
#import "BlogsItem.h"
#import "CustomViewController.h"

@interface SearchViewController () <UISearchBarDelegate>
@end

@implementation SearchViewController

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
    self.title = @"搜索";
    
    if (iOS_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    /*
    UIView *view = [[UIView alloc] init];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    view.frame = CGRectMake(0, 0 - CGRectGetHeight(_searchTableView.bounds), CGRectGetWidth(_searchTableView.frame), CGRectGetHeight(_searchTableView.bounds));
    view.backgroundColor = BackGroundColor;
    [_searchTableView addSubview:view];
    [view release];
     */
    _currentPage = 1; 
    
    [self createScrollViewItem];
}

- (void)createScrollViewItem
{
    CGFloat Y = 0;
    //分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 0.4)];
    lineLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [_searchScrollView addSubview:lineLabel];
    [lineLabel release];
    
    Y = Y+0.4;
    
    //综合新闻、软件更新－－热门
    //推荐博客－－推荐排行、阅读排行
    NSArray *array = [NSArray arrayWithObjects:@"综合新闻", @"软件更新", @"推荐博客", @"热门新闻", @"推荐排行", @"阅读排行", nil];
    for (int i = 0; i < [array count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(16, 44*i+Y*(i+1), JSScreenWidth-16*2, 44);
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; 
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goCustom:) forControlEvents:UIControlEventTouchUpInside];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_searchScrollView addSubview:button];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, button.frame.size.height+button.frame.origin.y, self.view.frame.size.width-14, 0.4)];
        lineLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
        
        if (i == [array count]/2-1) {
            lineLabel.backgroundColor = [UIColor darkGrayColor];
        } else {
            lineLabel.backgroundColor = [UIColor lightGrayColor];
        }
        
        [_searchScrollView addSubview:lineLabel];
        
        if (i == [array count]-1) {
            Y = lineLabel.frame.size.height+lineLabel.frame.origin.y;
        }
        
        [lineLabel release];
    }
    
    CGFloat hight = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 90 : 50;
    _searchScrollView.contentSize = CGSizeMake(0, Y+hight);
}
#pragma mark - 推荐
- (void)goCustom:(UIButton *)sender
{
    CustomViewController *custom = [[CustomViewController alloc] init];
    custom.title = sender.currentTitle;
    custom.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:custom animated:YES];
    [custom release];
}
#pragma mark - scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder] && [_searchArray count]) {
        [_searchBar resignFirstResponder];
    }
}
#pragma mark - 隐藏键盘
- (void)hideKeyBoard
{
    [_searchBar resignFirstResponder];
}
#pragma mark - searchbar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _currentPage = 1;
    [_searchArray removeAllObjects];
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    UIButton *button = (UIButton *)self.searchDisplayController.searchResultsTableView.tableFooterView;
    for (UIView *view in button.subviews) {
        [view removeFromSuperview];
    }
    self.searchDisplayController.searchResultsTableView.tableFooterView = nil;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchArray removeAllObjects];
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    UIButton *button = (UIButton *)self.searchDisplayController.searchResultsTableView.tableFooterView;
    for (UIView *view in button.subviews) {
        [view removeFromSuperview];
    }
    self.searchDisplayController.searchResultsTableView.tableFooterView = nil;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{ 
    [MobClick event:@"搜索"];
    _searchBar.text = searchBar.text;
    
    _currentPage = 1;
    
    self.searchDisplayController.searchResultsTableView.tableFooterView = nil;
    self.searchDisplayController.searchResultsTableView.delegate = nil;
    self.searchDisplayController.searchResultsTableView.dataSource = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([_searchArray count]) {
            [_searchArray removeAllObjects];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.searchDisplayController.searchResultsTableView.delegate = self;
            self.searchDisplayController.searchResultsTableView.dataSource = self;
            [self.searchDisplayController.searchResultsTableView reloadData];
            
            [self performSelector:@selector(searchContent:) withObject:_searchBar.text afterDelay:0.46f];
        });
    });
}
#pragma mark - 解析搜索XML
- (NSMutableArray *)resolveSearchXML:(CXMLDocument *)document
{
    NSMutableArray *array = [NSMutableArray array];
    
    CXMLElement *root = [document rootElement];
    NSArray *childs = [root children];
    for (CXMLElement *element in childs) {
        if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
            if ([[element name] isEqualToString:@"results"]) {
                for (int i = 0; i < [element childCount]; i++) {
                    SearchItem *item = [[[SearchItem alloc] init] autorelease];
                    
                    if ([[[element childAtIndex:i] name] isEqualToString:@"result"]) {
                        NSArray *childs = [[element childAtIndex:i] children];
                        for (CXMLElement *element in childs) {
                            if ([element isKindOfClass:NSClassFromString(@"CXMLElement")]) {
                                [item.searchItemsDict setObject:[element stringValue] forKey:[NSString stringWithFormat:@"searchItems%@", [element name]]];
                            }
                        }
                        
                        [array addObject:item];
                    }
                }
            }
        }
    }
    
    return array;
}
#pragma mark - 搜索
- (void)searchContent:(NSString *)content
{
    if ([content length] == 0 || [content isEqualToString:@" "]) {
        return;
    }
    [MobClick event:@"搜索"];
    
    if (self.searchDisplayController.searchResultsTableView.tableFooterView) {
        UIButton *button = (UIButton *)self.searchDisplayController.searchResultsTableView.tableFooterView;
        button.userInteractionEnabled = YES;
        [button setTitle:@"点击加载更多" forState:UIControlStateNormal];
        for (UIView *view in button.subviews) {
            if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
                UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)view;
                [indicatorView stopAnimating];
                [indicatorView removeFromSuperview];
            }
        }
    }
    
    if (_currentPage == 1) {
        [self.view makeToastActivity:CSToastPositionCenter];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@content=%@&pageIndex=%ld&pageSize=%d", searchAbsoluteURL, content, (long)_currentPage, 20];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    JSNetworkEngine *networkEngine = [[JSNetworkEngine alloc] init];
    
    [networkEngine startNetworkEngine:[NSString stringWithFormat:@"%@", url] withMethod:@"GET" params:nil withHandle:^(NSMutableData *resultData, NSError *error) {
        if (error) {
            NSLog(@"error:%@", error);
            [self.view makeToast:@"获取数据失败..." duration:1.0f position:@"center"];
            if (_currentPage > 1) {
                _currentPage = _currentPage-1;
            }
        } else {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[self resolveSearchXML:[JSNetworkEngine responseXML:resultData]]];
            
            if ([array count] > 0) {
                if (_currentPage == 1) {
                    _searchArray = [[NSMutableArray alloc] initWithArray:array];
                } else {
                    [_searchArray addObjectsFromArray:array];
                }
                
                if ([array count] < 20) {
                    UIButton *button = (UIButton *)self.searchDisplayController.searchResultsTableView.tableFooterView;
                    [button removeFromSuperview];
                    
                    self.searchDisplayController.searchResultsTableView.tableFooterView = nil;
                } else {
                    if (self.searchDisplayController.searchResultsTableView.tableFooterView == nil) {
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.backgroundColor = [UIColor clearColor];
                        button.frame = CGRectMake(0, 0, JSScreenWidth, 36);
                        [button setTitle:@"点击加载更多" forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
                        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
                        button.titleLabel.font = [UIFont systemFontOfSize:16];
                        [button addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
                        
                        CGSize size = [button.currentTitle sizeWithFont:[UIFont systemFontOfSize:16] forWidth:JSScreenWidth lineBreakMode:NSLineBreakByCharWrapping];
                        
                        CGFloat width = JSScreenWidth;
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width/2-size.width/2-10, 3, size.width+20, button.frame.size.height-3*2)];
                        label.backgroundColor = [UIColor clearColor];
                        label.layer.borderWidth = 0.4f;
                        label.layer.cornerRadius = 6;
                        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
                        [button addSubview:label];
                        [label release];
                        
                        self.searchDisplayController.searchResultsTableView.tableFooterView = button;
                    }
                }
                
                [self.searchDisplayController.searchResultsTableView reloadData];
                [self.view hideToastActivity];
                
                [self.searchDisplayController.searchResultsTableView setContentInset:UIEdgeInsetsZero];
                [self.searchDisplayController.searchResultsTableView setScrollIndicatorInsets:UIEdgeInsetsZero];
            } else {
                [self.view makeToast:@"获取数据失败..." duration:1.0f position:@"center"];
                [self.view hideToastActivity];
                
                if (_currentPage > 1) {
                    _currentPage = _currentPage-1;
                }
            }
        }
    }];
    [networkEngine release];
}
#pragma mark - 加载更多
- (void)loadMore:(UIButton *)sender
{
    [sender setTitle:@"" forState:UIControlStateNormal];
    sender.userInteractionEnabled = NO;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView startAnimating];
    indicatorView.center = CGPointMake(sender.frame.size.width/2, sender.frame.size.height/2);
    [sender addSubview:indicatorView];
    [indicatorView release];
    
    _currentPage = _currentPage+1;
    [self searchContent:_searchBar.text];
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
    
    NSTimeInterval timeInterval = (([self convertToTimeStamp:localeDate] - [self convertToTimeStamp:fromDate]))/1000;
    
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
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_searchArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    } 
    
    SearchItem *item = (SearchItem *)[_searchArray objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.numberOfLines = 2;
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    cell.textLabel.text = [item.searchItemsDict objectForKey:item.searchItemstitle];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@     发布于%@", [item.searchItemsDict objectForKey:item.searchItemsauthor], [self changeDate:[item.searchItemsDict objectForKey:item.searchItemspubDate]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchItem *item = (SearchItem *)[_searchArray objectAtIndex:indexPath.row];
    NSString *type = [item.searchItemsDict objectForKey:item.searchItemstype];
    
    DetialViewController *detial = [[DetialViewController alloc] init];
    if ([type isEqualToString:@"news"]) {
        detial.type = newsDetial;
    } else {
        detial.type = blogsDetial;
    }
    
    detial.itemId = [[item.searchItemsDict objectForKey:item.searchItemsobjid] copy];
    detial.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detial animated:YES];
    [detial release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} 

- (void)dealloc
{ 
    [_searchBar release];
    [_searchArray removeAllObjects];
    [_searchArray release];
    [_searchScrollView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSearchBar:nil]; 
    [self setSearchScrollView:nil];
    [super viewDidUnload];
}
@end
