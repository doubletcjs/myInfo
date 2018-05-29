//
//  CommentsWithReferCell.m
//  ITInfo2
//
//  Created by JianShaoChen on 5/22/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import "CommentsWithReferCell.h"

@implementation CommentsWithReferCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (UIView *)getReferVieWithItem:(CommentsItem *)item
{
    if (item.commentsrefers == nil || item.commentsrefers.count == 0) {
        return nil;
    }
    
    CGFloat width = JSScreenWidth-15*2;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 24, width, 3+36*(item.commentsrefers.count-1)+36)];
    view.backgroundColor = [UIColor colorWithRed:185.0/255 green:220.0/255 blue:1.0 alpha:1.0];
    
    for (int i = 0; i < item.commentsrefers.count; i++) {
        NSString *title = [[item.commentsrefers objectAtIndex:i] objectForKey:item.commentsrefertitle];
        NSString *body = [[item.commentsrefers objectAtIndex:i] objectForKey:item.commentsreferbody];
        
        UILabel *lbl_Title = [[UILabel alloc] initWithFrame:CGRectMake(2, 3+36*i, width-4, 16)];
        lbl_Title.text = title;
        lbl_Title.font = [UIFont boldSystemFontOfSize:12.0];
        lbl_Title.textColor = [UIColor colorWithRed:117.0/255 green:117.5/255 blue:117.0/255 alpha:1.0];
        lbl_Title.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:228.0/255 alpha:1.0];
        
        UILabel *lbl_Body = [[UILabel alloc] initWithFrame:CGRectMake(2, 3+36*i+19, width-4, 16)];
        lbl_Body.text = body;
        lbl_Body.textColor = [UIColor darkGrayColor];
        lbl_Body.font = [UIFont boldSystemFontOfSize:13.0];;
        lbl_Body.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        
        [view addSubview:lbl_Title];
        [view addSubview:lbl_Body];
        
        [lbl_Body release];
        [lbl_Title release];
    }
    
    return [view autorelease];
}
#pragma mark - 生成cell
- (void)defineCell:(CommentsItem *)item
{
    CGFloat width = JSScreenWidth-15*2;
    
    _referView = [[CommentsWithReferCell getReferVieWithItem:item] retain];
    [self addSubview:_referView];
    _contentLabel.numberOfLines = 0;
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    _contentLabel.font = font; 
    CGSize labelSize = [[item.commentsItemDict objectForKey:item.commentscontent] sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, 6+_referView.frame.size.height+_referView.frame.origin.y, width, labelSize.height);
    
    font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    _authorLabel.font = font;
    font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
    _dateLabel.font = font;
    _dateLabel.adjustsFontSizeToFitWidth = YES;
    
    _authorLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    _contentLabel.textColor = [UIColor blackColor];
    _dateLabel.textColor = [UIColor blackColor];
    
    for (UIView *view in self.subviews) {
        if (view.tag == 101) {
            [view removeFromSuperview];
        }
    }
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, [CommentsWithReferCell getReferVieWithItem:item].frame.size.height+24+labelSize.height+16, JSScreenWidth-15*2, 0.4)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    lineLabel.tag = 101;
    [self addSubview:lineLabel];
}
#pragma mark - 获取cell高度
+ (float)getCellHeight:(CommentsItem *)item
{
    CGFloat width = JSScreenWidth-15*2;
    
    CGFloat height = [CommentsWithReferCell getReferVieWithItem:item].frame.size.height+24;
    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    CGSize labelSize = [[item.commentsItemDict objectForKey:item.commentscontent] sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    height = height+labelSize.height;
    
    height = height+16;
    
    return height;
}
#pragma mark -
- (void)dealloc
{
    [_authorLabel release];
    [_dateLabel release];
    [_contentLabel release];
    [_referView release];
    [super dealloc];
}
@end
