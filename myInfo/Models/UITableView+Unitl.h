//
//  UITableView+Unitl.h
//  WeatherMood
//
//  Created by JianShao Chan on 5/18/16.
//  Copyright © 2016 Sam Cooper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Unitl)

- (void)setupRefresh:(id)target headerAction:(SEL)headerAction footerAction:(SEL)footerAction;

@end
