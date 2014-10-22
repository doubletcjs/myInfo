//
//  CollectionViewController.m
//  myInfo
//
//  Created by JianShaoChen on 8/9/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "CollectionViewController.h"
#import "DetialViewController.h"

@interface CollectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) NSMutableDictionary *collectionDict;

@end

@implementation CollectionViewController

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
    self.title = @"收藏";
    
    UIView *view = [[UIView alloc] init];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    view.frame = CGRectMake(0, 0 - CGRectGetHeight(_collectionTableView.bounds), CGRectGetWidth(_collectionTableView.frame), CGRectGetHeight(_collectionTableView.bounds));
    view.backgroundColor = BackGroundColor;
    [_collectionTableView addSubview:view];
    [view release]; 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.collectionDict = [NSMutableDictionary dictionaryWithContentsOfFile:[self collectionDirectory]];
    [_collectionTableView reloadData];
}
#pragma mark - 收藏目录
- (NSString *)collectionDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@".Collection"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *plistPath = [path stringByAppendingPathComponent:@"collection.plist"];
	return plistPath;
}
#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_collectionDict allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.numberOfLines = 2;
    
    cell.textLabel.text = [[[_collectionDict allValues] objectAtIndex:indexPath.row] objectForKey:@"title"]; 
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [[_collectionDict allValues] objectAtIndex:indexPath.row];
    DetialViewController *detial = [[DetialViewController alloc] init];
    
    detial.itemId = [[dict objectForKey:@"id"] copy]; 
    detial.type = [[dict objectForKey:@"type"] intValue];
    
    detial.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detial animated:YES];
    [detial release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_collectionDict removeObjectForKey:[[_collectionDict allKeys] objectAtIndex:indexPath.row]];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [_collectionDict writeToFile:[self collectionDirectory] atomically:YES];
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
    [_collectionDict removeAllObjects];
    [_collectionDict release];
    [_collectionTableView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setCollectionTableView:nil];
    [super viewDidUnload];
}
@end
