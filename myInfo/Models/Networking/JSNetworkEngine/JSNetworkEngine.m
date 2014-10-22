//
//  JSNetworkEngine.m
//  JSNetworkEngine
//
//  Created by kaykwai on 14-8-11.
//  Copyright (c) 2014年 com.i-mybest. All rights reserved.
//

#import "JSNetworkEngine.h"
#import "MTAnimatedLabel.h"
#import "CXMLDocument.h"

@interface JSNetworkEngine () <NSURLConnectionDelegate>
{
    UIWindow *_originalWindow;
    UIView *_backgroundView;
    UIActivityIndicatorView *_indicatorView;
}

#if TARGET_OS_IPHONE
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;
#endif
@property (strong, nonatomic) NSMutableData *mutableData;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (strong, nonatomic) NSURLConnection *urlConnection;
@property (strong, nonatomic) MTAnimatedLabel *animatedLabel;

@end

@implementation JSNetworkEngine
@synthesize complectionHandle = _complectionHandle;

- (id)init
{
    self = [super init];
    
    if (self == [super init]) { 
        self.timeoutInterval = 20;
        self.cacheLimitInterval = 60*10;
        self.cacheData = YES;
        
        if (self.engineStyle != engineStyleNoUI) {
            self.layer.cornerRadius = 6.0;
            self.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.8f];
            
            self.layer.shadowOffset = CGSizeMake(0, 0);
            if (self.engineStyle == engineStyleNormal) {
                self.layer.shadowOpacity = 0.6f;
                self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
                self.layer.borderWidth = 2;
                self.layer.borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.8f].CGColor;
            } else {
                self.layer.shadowOpacity = 1.0f;
                self.layer.shadowColor = [UIColor whiteColor].CGColor;
            }
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
                                                         name:UIDeviceOrientationDidChangeNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reStartAnimating) name:UIApplicationWillEnterForegroundNotification object:nil];
        }
    }
    
    return self;
}

- (id)initStyle:(JSEngineStyle)engineStyle
{
    self.engineStyle = engineStyle;
    
    return [self init];
}
#pragma mark - 界面
- (void)orientationChanged:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            [self rotate:orientation];
        } completion:^(BOOL finished) {
        }];
    });
}

- (void)rotate:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation(3*M_PI/2);
        [self setTransform:rotation];
    }else if (orientation == UIInterfaceOrientationLandscapeRight) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI/2);
        [self setTransform:rotation];
    }else if (orientation == UIInterfaceOrientationPortrait) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation(0);
        [self setTransform:rotation];
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI);
        [self setTransform:rotation];
    }
}

- (void)show
{
    CGRect rect = [UIScreen mainScreen].bounds;
    
    _originalWindow = [[UIWindow alloc] initWithFrame:rect];
    _originalWindow.windowLevel = UIWindowLevelNormal;
    
    _backgroundView  = [[UIView alloc] initWithFrame:rect];
    _backgroundView.alpha = 0.4;
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.center = _originalWindow.center;
    self.center = _originalWindow.center;
    
    [_originalWindow addSubview:_backgroundView];
    [_originalWindow addSubview:self];
    [_originalWindow becomeKeyWindow];
    [_originalWindow makeKeyAndVisible];
    
    if (_engineStyle == engineStyleNormal) {
        [self defaultStyle];
    } else {
        [self onlyLoadingStyle];
    }
}

- (void)onlyLoadingStyle
{
    [self orientationChanged:nil];
    
    self.frame = CGRectMake(0, 0, 100, 100);
    self.center = _originalWindow.center;
    self.alpha = 0;
    
     _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
     _indicatorView.hidesWhenStopped = YES;
     [_indicatorView startAnimating];
     _indicatorView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
     
     [self addSubview:_indicatorView];
    
    [UIView animateWithDuration:0.76f animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)defaultStyle
{
    [self orientationChanged:nil];
    
    self.frame = CGRectMake(0, 0, 150, 40);
    self.center = _originalWindow.center;
    self.alpha = 0;
    
    /*
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicatorView.hidesWhenStopped = YES;
    [_indicatorView startAnimating];
    _indicatorView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [self addSubview:_indicatorView];
     */
    _animatedLabel = [[MTAnimatedLabel alloc] initWithFrame:CGRectMake(37, 10, 110, 34)];
    _animatedLabel.backgroundColor = [UIColor clearColor];
    _animatedLabel.textColor = [UIColor whiteColor];
    _animatedLabel.font = [UIFont boldSystemFontOfSize:16];
    _animatedLabel.textAlignment = NSTextAlignmentCenter;
    _animatedLabel.text = @"Loading...";
    
    [_animatedLabel startAnimating];
    _animatedLabel.tint = [UIColor grayColor];
    [self addSubview:_animatedLabel];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopButton.frame = CGRectMake(10, 10, 20, 20);
    stopButton.backgroundColor = [UIColor clearColor];
    [stopButton setImage:[UIImage imageNamed:@"JSNetworkEngine_close_button.png"] forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(hideAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:stopButton];
    
    stopButton = nil;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(38, 2, 2, 36)];
    label.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.8f];
    [self addSubview:label];
    label = nil;
    
    [UIView animateWithDuration:0.76f animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)hideAction
{
    [self hide];
    
    if (self.complectionHandle) {
        self.complectionHandle(nil, nil);
    }
}

- (void)hide
{ 
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_indicatorView) {
            [_indicatorView stopAnimating];
        }
        
        [self removeFromSuperview];
        [_backgroundView removeFromSuperview];
        [_originalWindow removeFromSuperview];
        [[[UIApplication sharedApplication] keyWindow] makeKeyWindow];
    });
}
#pragma mark - 网络请求
- (void)endBackgroundTask {
#if TARGET_OS_IPHONE
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
            self.backgroundTaskId = UIBackgroundTaskInvalid;
        }
    });
#endif
}

- (void)startNetworkEngine:(NSString *)urlPath withMethod:(NSString *)method params:(NSDictionary *)parames withHandle:(ComplectionHandle)handle
{
#if TARGET_OS_IPHONE
    self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
                self.backgroundTaskId = UIBackgroundTaskInvalid;
                
                [self cancel];
            }
        });
    }];
#endif
    if (handle) {
        self.complectionHandle = handle;
    }
    
    NSArray *keys = [parames allKeys];
    NSArray *keysSortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    if ([method isEqualToString:@"GET"]) {
        NSLog(@"请求参数:%@", parames);
        NSMutableString *urlStr = [[NSMutableString alloc] initWithFormat:@"%@", urlPath]; 
        
        for (int i = 0; i < [keysSortedArray count]; i++) {
            NSString *key = [keysSortedArray objectAtIndex:i];
            
            NSString *value = [parames objectForKey:key];
            
            if ([key length] > 1) {
                if (i == [keysSortedArray count]-1) {
                    [urlStr appendFormat:@"%@=%@", key, value];
                } else {
                    [urlStr appendFormat:@"%@=%@&", key, value];
                }
            } else {
                if (i == [keysSortedArray count]-1) {
                    [urlStr appendFormat:@"%@", value];
                } else {
                    [urlStr appendFormat:@"%@/", value];
                }
            }
        }
        NSLog(@"%@", urlStr);
        
        _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                       timeoutInterval:_timeoutInterval];
        
        urlStr = nil;
    } 
    
    [_request setHTTPMethod:method];
    
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"] || [method isEqualToString:@"PATCH"]) {
        [_request setHTTPBody:[NSData data]];
    } else {
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _urlConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
        [_urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_urlConnection start];
    });
}
#pragma mark - NSURLConnection delegates
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _mutableData = nil;
    [self endBackgroundTask];
    
    [self hide];
    
    if (self.complectionHandle) {
        self.complectionHandle(nil, error);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSUInteger size = [_response expectedContentLength] < 0 ? 0 : (NSUInteger)[_response expectedContentLength];
    _response = (NSHTTPURLResponse *)response;
    
    // dont' save data if the operation was created to download directly to a stream.
    _mutableData = [NSMutableData dataWithCapacity:size];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
        if (self.complectionHandle) {
            self.complectionHandle(_mutableData, nil);
        }
    }
    
    if (_response.statusCode >= 300 && _response.statusCode < 400) {
        if(_response.statusCode == 301) {
            NSLog(@"%@ has moved to %@", connection.currentRequest.URL, [_response.URL absoluteString]);
        } else if(_response.statusCode == 304) {
            
        } else if(_response.statusCode == 307) {
            NSLog(@"%@ temporarily redirected", connection.currentRequest.URL);
        } else {
            NSLog(@"%@ returned status %d", connection.currentRequest.URL, (int) _response.statusCode);
        }
        
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:_response.statusCode userInfo:_response.allHeaderFields];
        
        if (self.complectionHandle) {
            self.complectionHandle(nil, error);
        }
        
        error = nil;
    } else if (_response.statusCode >= 400 && _response.statusCode < 600) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:_response.statusCode userInfo:_response.allHeaderFields];
        
        if (self.complectionHandle) {
            self.complectionHandle(nil, error);
        }
        
        error = nil;
    }
    
    [self performSelector:@selector(hide) withObject:self afterDelay:0.76f];
    [self endBackgroundTask];
}
#pragma mark - 取消网络请求
- (void)cancel
{
    @synchronized(self) {
        if (self.complectionHandle) {
            self.complectionHandle(nil, nil);
        }
        
        [self endRequest];
    }
}

- (void)endRequest
{
    @synchronized(self) {
        _mutableData = nil;
        [_urlConnection cancel];
        _urlConnection = nil;
    }
}
#pragma mark - 解析JSON
+ (id)responseJSON:(id)data
{
    if (data == nil) return nil;
    NSError *error = nil;
    id returnValue = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) NSLog(@"JSON Parsing Error: %@", error);
    
    return returnValue;
}
#pragma mark - 解析XML
+ (id)responseXML:(id)data
{
    if (data == nil) return nil;
    NSError *error = nil;
    CXMLDocument *document = [[CXMLDocument alloc] initWithData:data
                                                        options:0
                                                          error:&error];
    
    if (error) NSLog(@"JSON Parsing Error: %@", error);
    
    return document;
}
#pragma mark - loding动画
- (void)reStartAnimating
{
    [_animatedLabel startAnimating];
}
#pragma mark -
- (void)dealloc
{
    [self endRequest];
    [_indicatorView stopAnimating];
    _indicatorView = nil;
    _backgroundView = nil;
    _originalWindow = nil;
    [_animatedLabel stopAnimating];
    _animatedLabel = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

@end
