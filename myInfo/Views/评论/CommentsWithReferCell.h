//
//  CommentsWithReferCell.h
//  ITInfo2
//
//  Created by JianShaoChen on 5/22/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsItem.h"

@interface CommentsWithReferCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *authorLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) UIView *referView;

//生成cell
- (void)defineCell:(CommentsItem *)item;
//获取cell高度
+ (float)getCellHeight:(CommentsItem *)item;

@end
