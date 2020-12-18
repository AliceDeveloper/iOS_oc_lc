//
//  BaseNavViewController.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/16.
//  Copyright © 2020 lc. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏背景色
    self.navigationBar.barTintColor = [UIColor lc_tint];
    // 导航栏左右按钮字体颜色
    self.navigationBar.tintColor = [UIColor lc_white];
    // 导航栏标题字体颜色
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                                 NSForegroundColorAttributeName : [UIColor lc_white]}];
}

@end
