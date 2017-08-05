//
//  UINavigationItem+Unitl.m
//  NutritionOnline
//
//  Created by i-mybest on 14-8-20.
//  Copyright (c) 2014年 i-mybest. All rights reserved.
//

#import "UINavigationItem+Unitl.h"

@implementation UINavigationItem (Unitl)

- (UIBarButtonItem *)backBarButtonItem
{
    return [[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
}

@end
