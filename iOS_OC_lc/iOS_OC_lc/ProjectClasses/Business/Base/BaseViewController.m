//
//  BaseViewController.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/16.
//  Copyright © 2020 lc. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lc_white];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
}

@end
