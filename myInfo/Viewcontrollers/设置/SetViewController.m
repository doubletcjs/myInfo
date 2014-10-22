//
//  FireViewController.m
//  myInfo
//
//  Created by JianShaoChen on 8/3/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "SetViewController.h"
#import "UMFeedbackViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

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
    self.title = @"设置";
    
    UIView *view = [[UIView alloc] init];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    view.frame = CGRectMake(0, 0 - CGRectGetHeight(_setTableView.bounds), CGRectGetWidth(_setTableView.frame), CGRectGetHeight(_setTableView.bounds));
    view.backgroundColor = BackGroundColor;
    [_setTableView addSubview:view];
    [view release];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"cache"];
        self.fileSize = [NSString stringWithFormat:@"%.2f M", [self folderSizeAtPath:path]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [_setTableView reloadData];
        });
    });
}
#pragma mark - 单个文件的大小
- (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
#pragma mark - 遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    cell.textLabel.font = font;
    
    switch (indexPath.row) {
        case 0:
        {
            UILabel *cacheLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
            cacheLabel.backgroundColor = [UIColor clearColor];
            cacheLabel.textColor = [UIColor blackColor];
            cacheLabel.text = _fileSize;
            cacheLabel.textAlignment = NSTextAlignmentRight;
            cacheLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
            cell.accessoryView = cacheLabel;
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.text = @"缓存";
            [cacheLabel release];
        }
            break;
        case 1:
        {
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text =  [NSString stringWithFormat:@"博客新闻 v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
        }
            break;
        case 2:
        {
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.text = @"意见反馈";
        }
            break;
        case 3:
        {
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.text = @"给我评分";
        }
            break;
        case 4:
        {
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.text = @"检测更新";
        }
            break;
            
        default:
        {
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            if ([[[_fileSize componentsSeparatedByString:@" "] firstObject] floatValue] > 0.01f) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"清理缓存" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清理" otherButtonTitles:nil];
                [actionSheet showInView:self.navigationController.view];
                [actionSheet release];
            }
        }
            break;
        case 2:
        {
            UMFeedbackViewController *feedBackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
            feedBackViewController.appkey = UMKEY;
            feedBackViewController.view.backgroundColor = [UIColor whiteColor];
            feedBackViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedBackViewController animated:YES];
            [feedBackViewController release];
        }
            break;
        case 3:
        {
            //NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"827116087"];
            [MobClick event:@"评分"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/bo-ke-xin-wen/id827116087?l=en&mt=8"]];
        }
            break;
        case 4:
        {
            [self.view makeToastActivity];
            [MobClick checkUpdateWithDelegate:self selector:@selector(appUpdate:)];
        }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 检测更新
- (void)appUpdate:(NSDictionary *)appInfo
{
    [self.view hideToastActivity];
    
    NSString *version = [appInfo objectForKey:@"version"];
    NSString *current_version = [appInfo objectForKey:@"current_version"];
    NSString *update_log = [appInfo objectForKey:@"update_log"];
    BOOL update = [[appInfo objectForKey:@"update"] boolValue];
    
    if (![version isEqualToString:current_version] && update) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"有可用的新版本%@", version] message:update_log delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立刻更新", nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"暂无可用更新" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [MobClick event:@"更新"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/bo-ke-xin-wen/id827116087?ls=1&mt=8"]];
    }
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self.view makeToastActivityWithMsg:@"清理中..."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
            [[SDURLCache sharedURLCache] removeAllCachedResponses];
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"cache"];
                
                self.fileSize = [NSString stringWithFormat:@"%.2f M", [self folderSizeAtPath:path]];
                
                [self.view hideToastActivity];
                [_setTableView reloadData];
            });
        });
    }
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_setTableView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSetTableView:nil];
    [super viewDidUnload];
}
@end
