//
//  ThreeViewController.h
//  myInfo
//
//  Created by JianShaoChen on 8/3/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) NSMutableArray *searchArray;

@property (assign, nonatomic) NSInteger currentPage;

@property (retain, nonatomic) IBOutlet UIScrollView *searchScrollView;

@end
