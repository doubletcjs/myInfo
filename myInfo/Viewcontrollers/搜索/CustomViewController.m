//
//  CustomViewController.m
//  myInfo
//
//  Created by i-mybest on 14-9-9.
//  Copyright (c) 2014年 Sam Cooper Studio. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

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
    
    requestType type = news;
    if ([self.title isEqualToString:@"综合新闻"]) {
        type = synthesizeNews;
    } else if ([self.title isEqualToString:@"软件更新"]) {
        type = softNews;
    } else if ([self.title isEqualToString:@"推荐博客"]) {
        type = recommendBlogs;
    } else if ([self.title isEqualToString:@"热门新闻"]) {
        type = hotNews;
    } else if ([self.title isEqualToString:@"推荐排行"]) {
        type = hotRecommend;
    } else if ([self.title isEqualToString:@"阅读排行"]) {
        type = hotRead;
    }
    
    JSTableView *tableView = [[JSTableView alloc] initWithType:type];
    tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    tableView.autoresizingMask = self.view.autoresizingMask;
    tableView.navigationController = self.navigationController;
    [self.view addSubview:tableView];
    [tableView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

@end
