//
//  AppDelegate.m
//  myInfo
//
//  Created by JianShaoChen on 8/3/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "WXApi.h"

@interface AppDelegate () <WXApiDelegate>
{
    
}

@end

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}
#pragma mark - 强制更新
- (void)appUpdate:(NSDictionary *)appUpdateInfo
{
    NSString *version = [appUpdateInfo objectForKey:@"version"];
    NSString *current_version = [appUpdateInfo objectForKey:@"current_version"];
    NSString *update_log = [appUpdateInfo objectForKey:@"update_log"];
    BOOL update = [[appUpdateInfo objectForKey:@"update"] boolValue];
    
    if (![version isEqualToString:current_version] && update) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"有可用的新版本%@", version] message:update_log delegate:self
                                                  cancelButtonTitle:@"取消" otherButtonTitles:@"访问 Store", nil];
        [alertView show];
        alertView.tag = 10001;
        [alertView release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10001 && buttonIndex != alertView.cancelButtonIndex) {
        [MobClick event:@"更新"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/bo-ke-xin-wen/id827116087?l=en&mt=8"]];
    }
}

- (void)initUMSocial
{
    [MobClick startWithAppkey:UMKEY];
    [MobClick checkUpdateWithDelegate:self selector:@selector(appUpdate:)];
}
#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (!TARGET_IPHONE_SIMULATOR) {
        [self initUMSocial];
    }
    [WXApi registerApp:@"wxe6f7fa433c3b9490"];
    
    self.window = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    _window.backgroundColor = [UIColor whiteColor];
    
    TabBarViewController *tabBar = [[[TabBarViewController alloc] init] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:tabBar] autorelease];
    
    _navigationController.navigationBarHidden = YES;
    
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"cache"];
    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024*10   // 1MB mem cache
                                                         diskCapacity:1024*1024*200 // 10MB disk cache
                                                             diskPath:path];
    
    [NSURLCache setSharedURLCache:urlCache];
    [urlCache release];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 微信回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
}

@end
