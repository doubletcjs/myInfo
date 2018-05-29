//
//  AppDelegate.m
//  myInfo
//
//  Created by JianShaoChen on 8/3/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "GDTSplashAd.h"
#import "GDTMobInterstitial.h"

@interface AppDelegate () <GDTSplashAdDelegate, GDTMobInterstitialDelegate>
{
    
}
@property (nonatomic) GDTSplashAd *splashAd;
@property (strong, nonatomic) GDTMobInterstitial *interstitialAd;

@end

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (void)initUMSocial
{
    if (!TARGET_IPHONE_SIMULATOR) {
        [MobClick setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        
        UMConfigInstance.appKey = UMKEY;
        [MobClick startWithConfigure:UMConfigInstance];
    }
}
#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (!TARGET_IPHONE_SIMULATOR) {
        [self initUMSocial];
    }
    
    self.window = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    _window.backgroundColor = [UIColor whiteColor];
    
    TabBarViewController *tabBar = [[[TabBarViewController alloc] init] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:tabBar] autorelease];
    
    _navigationController.navigationBarHidden = YES;
    
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"cache"];
    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024*10   // 1MB mem cache
                                                         diskCapacity:1024*1024*200 // 10MB disk cache
                                                             diskPath:path];
    
    [NSURLCache setSharedURLCache:urlCache];
    [urlCache release];
    
    _splashAd = [[GDTSplashAd alloc] initWithAppkey:@"1102537476" placementId:@"8040226425520632"];
    _splashAd.fetchDelay = 2;
    _splashAd.delegate = self;
    
    [_splashAd loadAdAndShowInWindow:_window];
    
    _interstitialAd = [[GDTMobInterstitial alloc] initWithAppkey:@"1102537476" placementId:@"2040225485132073"];
    _interstitialAd.delegate = self;
    [_interstitialAd loadAd];
    
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
    [_interstitialAd presentFromRootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - GDTSplashAdDelegate
/**
 *  开屏广告成功展示
 */
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd {
    NSLog(@"%s", __func__);
}
/**
 *  开屏广告展示失败
 */
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error {
    NSLog(@"%s\n%@", __func__, error);
}
#pragma mark - GDTMobInterstitialDelegate
/**
 *  广告预加载成功回调
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 */
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial {
    NSLog(@"%s", __func__);
}
/**
 *  广告预加载失败回调
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error {
    NSLog(@"%s", __func__);
}
/**
 *  插屏广告视图展示成功回调
 *  详解: 插屏广告展示成功回调该函数
 */
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial {
    NSLog(@"%s", __func__);
}
/**
 *  插屏广告展示结束回调
 *  详解: 插屏广告展示结束回调该函数
 */
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial {
    NSLog(@"%s", __func__);
    [_interstitialAd loadAd];
}
@end
