//
//  CommentCell.m
//  ITInfo
//
//  Created by JianShaoChen on 2/22/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "CnblogCommentCell.h"

@implementation CnblogCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 生成cell
- (void)defineCell:(CnblogCommentItem *)item
{
    CGFloat width = JSScreenWidth-15*2;
    _contentLabel.numberOfLines = 0;
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    _contentLabel.font = font;
    CGSize labelSize = [[item.cnblogCommentsItemDict objectForKey:item.cnblogCommentscontent] sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, 26, width, labelSize.height);
    
    font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    _authorLabel.font = font;
    font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
    _authorLabel.font = font;
    
    _authorLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    _contentLabel.textColor = [UIColor blackColor];
    _dateLabel.textColor = [UIColor blackColor];
    
    for (UIView *view in self.subviews) {
        if (view.tag == 101) {
            [view removeFromSuperview];
        }
    }
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 26+labelSize.height+10, JSScreenWidth-15*2, 0.4)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    lineLabel.tag = 101;
    [self addSubview:lineLabel];
}
#pragma mark - 获取cell高度
+ (float)getCellHeight:(CnblogCommentItem *)item
{
    CGFloat width = JSScreenWidth-15*2;
    
    CGFloat height = 26;
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    CGSize labelSize = [[item.cnblogCommentsItemDict objectForKey:item.cnblogCommentscontent] sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    height = height+labelSize.height;
    
    height = height+10;
    
    return height;
}
#pragma mark -
- (void)dealloc
{
    [_authorLabel release];
    [_dateLabel release];
    [_contentLabel release];
    [super dealloc];
}
@end
