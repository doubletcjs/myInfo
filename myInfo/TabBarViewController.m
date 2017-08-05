//
//  TabBarViewController.m
//  myInfo
//
//  Created by JianShaoChen on 8/3/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "TabBarViewController.h"

#import "NewViewController.h"
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
    
    SetViewController *set = [[SetViewController alloc] init];
    UINavigationController *setNav = [[[UINavigationController alloc] init] autorelease];
    [setNav pushViewController:set animated:NO];
    [set release];
    
    setNav.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"ico_settings"] tag:4] autorelease];
    
    self.viewControllers = [NSArray arrayWithObjects:newNav, setNav, nil];
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
