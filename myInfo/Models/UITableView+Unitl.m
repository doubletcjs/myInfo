//
//  UITableView+Unitl.m
//  WeatherMood
//
//  Created by JianShao Chan on 5/18/16.
//  Copyright © 2016 Sam Cooper Studio. All rights reserved.
//

#import "UITableView+Unitl.h"

@implementation UITableView (Unitl)

- (void)setupRefresh:(id)target headerAction:(SEL)headerAction footerAction:(SEL)footerAction {
    if (headerAction) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:headerAction];
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
        [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
        header.stateLabel.font = [UIFont systemFontOfSize:14];
        header.lastUpdatedTimeLabel.hidden = YES;
        
        self.mj_header = header;
    }
    
    if (footerAction) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:footerAction];
        [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"释放加载" forState:MJRefreshStatePulling];
        [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        footer.stateLabel.font = [UIFont systemFontOfSize:14]; 
        
        self.mj_footer = footer;
    }
    
    self.mj_header.hidden = YES;
    self.mj_footer.hidden = YES;
}

@end
