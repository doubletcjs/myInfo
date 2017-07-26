//
//  FireViewController.m
//  myInfo
//
//  Created by JianShaoChen on 8/3/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "SetViewController.h" 

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
    return 3;
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
            cell.textLabel.text =  [NSString stringWithFormat:@"博客新闻 v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        }
            break;
        case 2:
        {
            cell.accessoryView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.text = @"给我评分";
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
            [MobClick event:@"评分"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/bo-ke-xin-wen/id827116087?l=en&mt=8"]];
        }
            break;
            
        default:
            break;
    }
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
    [_setTableView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSetTableView:nil];
    [super viewDidUnload];
}
@end
