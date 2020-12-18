//
//  UIColor+LC.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/12/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (LC)

#pragma mark - 背景颜色
+ (UIColor *)lc_black;
+ (UIColor *)lc_white;
+ (UIColor *)lc_backgroundColor245;
+ (UIColor *)lc_backgroundColor235;
+ (UIColor *)lc_backgroundColor225;
+ (UIColor *)lc_line;

#pragma mark - 文字颜色
+ (UIColor *)lc_textColor32;
+ (UIColor *)lc_textColor51;
+ (UIColor *)lc_textColor86;
+ (UIColor *)lc_textColor102;
+ (UIColor *)lc_textColor153;

#pragma mark - APP 其他色
+ (UIColor *)lc_tint;
+ (UIColor *)lc_redUp;
+ (UIColor *)lc_greenDown;
+ (UIColor *)lc_blueDark;

@end

NS_ASSUME_NONNULL_END
