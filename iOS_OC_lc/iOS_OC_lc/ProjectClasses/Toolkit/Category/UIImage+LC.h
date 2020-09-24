//
//  UIImage+LC.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/17.
//  Copyright © 2020 lc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LC)

// 返回一张可以随意拉伸不变形的图片，一般用于聊天气泡
+ (UIImage *)imageResizable:(UIEdgeInsets)edgeInsets imageName:(NSString *)name;
// 修改本地图片透明度，范围0-1
+ (UIImage *)imageAlpha:(CGFloat)alpha imageName:(NSString *)name;
// 压缩本地图片质量，newSize：大小超过多少才进行压缩，单位 KB
+ (UIImage *)imageCompress:(NSUInteger)newSize imageName:(NSString *)name;
// 根据颜色创建图片
+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize;

@end

NS_ASSUME_NONNULL_END
