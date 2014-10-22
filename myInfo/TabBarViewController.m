//
//  TabBarViewController.m
//  myInfo
//
//  Created by JianShaoChen on 8/3/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "TabBarViewController.h"

#import "NewViewController.h"
#import "BlogViewController.h"
#import "SearchViewController.h"
#import "CollectionViewController.h"
#import "SetViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

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
    
    NewViewController *new = [[NewViewController alloc] init];
    UINavigationController *newNav = [[[UINavigationController alloc] init] autorelease];
    [newNav pushViewController:new animated:NO];
    [new release];
    
    newNav.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"新闻" image:[UIImage imageNamed:@"tabbar_news.png"] tag:4] autorelease];
    
    BlogViewController *blog = [[BlogViewController alloc] init];
    UINavigationController *blogNav = [[[UINavigationController alloc] init] autorelease];
    [blogNav pushViewController:blog animated:NO];
    [blog release];
    
    blogNav.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"博客" image:[UIImage imageNamed:@"tab_home.png"]  tag:1] autorelease];
    
    SearchViewController *search = [[SearchViewController alloc] init];
    UINavigationController *searchNav = [[[UINavigationController alloc] init] autorelease];
    [searchNav pushViewController:search animated:NO];
    [search release];
    
    searchNav.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:2] autorelease];
    
    CollectionViewController *collection = [[CollectionViewController alloc] init];
    UINavigationController *collectionNav = [[[UINavigationController alloc] init] autorelease];
    [collectionNav pushViewController:collection animated:NO];
    [collection release];
    
    collectionNav.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"收藏" image:[UIImage imageNamed:@"choiceness.png"] tag:4] autorelease];
    
    SetViewController *set = [[SetViewController alloc] init];
    UINavigationController *setNav = [[[UINavigationController alloc] init] autorelease];
    [setNav pushViewController:set animated:NO];
    [set release];
    
    setNav.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"tabbar_setting.png"] tag:4] autorelease];
    
    self.viewControllers = [NSArray arrayWithObjects:newNav, blogNav, searchNav, collectionNav, setNav, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
