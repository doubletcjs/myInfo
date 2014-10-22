//
//  FireViewController.h
//  myInfo
//
//  Created by JianShaoChen on 8/3/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetViewController : UIViewController <UIActionSheetDelegate>

@property (retain, nonatomic) IBOutlet UITableView *setTableView;

@property (copy, nonatomic) NSString *fileSize;

@end
