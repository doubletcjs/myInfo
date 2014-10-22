//
//  CommentsCell.m
//  ITInfo2
//
//  Created by JianShaoChen on 5/22/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "CommentsCell.h"

@implementation CommentsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 生成cell
- (void)defineCell:(CommentsItem *)item
{
    CGFloat width = 304;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        width = 768-16;
    }
    
    _contentLabel.numberOfLines = 0;
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    _contentLabel.font = font;
    CGSize labelSize = [[item.commentsItemDict objectForKey:item.commentscontent] sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, 26, width, labelSize.height);
    
    font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    _authorLabel.font = font;
    font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
    _authorLabel.font = font;
    
    _authorLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    _contentLabel.textColor = [UIColor blackColor];
    _dateLabel.textColor = [UIColor blackColor];
}
#pragma mark - 获取cell高度
+ (float)getCellHeight:(CommentsItem *)item
{
    CGFloat width = 304;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        width = 768-16;
    }
    
    CGFloat height = 26;
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    CGSize labelSize = [[item.commentsItemDict objectForKey:item.commentscontent] sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
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
