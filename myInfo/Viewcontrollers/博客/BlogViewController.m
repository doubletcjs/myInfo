//
//  SecondViewController.m
//  myInfo
//
//  Created by JianShaoChen on 8/3/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "BlogViewController.h"

@interface BlogViewController ()

@property (nonatomic, retain) UIPageControl *pageControl;

@end

@implementation BlogViewController

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
    self.title = @"博客";
    
    if (iOS_7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _blogScrollView.showsHorizontalScrollIndicator = NO;
    _blogScrollView.showsVerticalScrollIndicator = NO;
    _blogScrollView.pagingEnabled = YES;
    _blogScrollView.contentSize = CGSizeMake(width*2, 0);
    
    for (int i = 0; i < 2; i++) {
        JSTableView *tableView = [[JSTableView alloc] initWithType:i+2];
        tableView.frame = CGRectMake(width*i, 0, _blogScrollView.frame.size.width, _blogScrollView.frame.size.height);
        tableView.autoresizingMask = _blogScrollView.autoresizingMask;
        tableView.navigationController = self.navigationController;
        [_blogScrollView addSubview:tableView];
        [tableView release];
    }
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    self.navigationItem.titleView = _pageControl;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = 2;
    _pageControl.backgroundColor = [UIColor clearColor];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_blogScrollView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBlogScrollView:nil];
    [super viewDidUnload];
}
@end
