//
//  JSTableView.h
//  myInfo
//
//  Created by JianShaoChen on 8/14/14.
//  Copyright (c) 2014 Sam Cooper Studio. All rights reserved.
//

#import <UIKit/UIKit.h> 

@interface JSTableView : UITableView
{
	id _myDelegate;
}

@property (retain, nonatomic) UINavigationController *navigationController;

@property(nonatomic,assign,getter=getMyDelegate) id	myDelegate;

@property (copy, nonatomic) NSString *commentID;
- (id)initWithType:(requestType)type withCommentID:(NSString *)commentID;
- (id)initWithType:(requestType)type;
@end
@protocol myTableViewDelegate
@optional
- (void)getCommentNumbers:(NSInteger)count;
@end