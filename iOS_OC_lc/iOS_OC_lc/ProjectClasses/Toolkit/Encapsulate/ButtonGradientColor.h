//
//  ButtonGradientColor.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

/*
渐变色的按钮，只包含两种颜色
备注：所有的属性设置必须要在 layoutSubviews 之前
*/
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ButtonGradientColor : UIButton

// 圆角
@property (nonatomic, assign) CGFloat radius;
// enabled == NO 时显示的颜色，默认浅灰色
@property (nonatomic, strong) UIColor *bgColor;
// enabled == YES 时显示的颜色，默认浅灰到深灰
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
// enabled == YES 时
// isHorizontal == YES 表示从左至右渐变，isHorizontal == NO 表示从上至下渐变，默认YES
@property (nonatomic, assign) BOOL isHorizontal;

@end

NS_ASSUME_NONNULL_END
