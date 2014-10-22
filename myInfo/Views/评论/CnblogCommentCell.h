//
//  CommentCell.h
//  ITInfo
//
//  Created by JianShaoChen on 2/22/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CnblogCommentItem.h"

@interface CnblogCommentCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *authorLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;

//生成cell
- (void)defineCell:(CnblogCommentItem *)item;
//获取cell高度
+ (float)getCellHeight:(CnblogCommentItem *)item;
@end
