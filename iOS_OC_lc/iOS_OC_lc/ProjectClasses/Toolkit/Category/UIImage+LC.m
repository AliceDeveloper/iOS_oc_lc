//
//  UIImage+LC.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/17.
//  Copyright © 2020 lc. All rights reserved.
//

#import "UIImage+LC.h"

@implementation UIImage (LC)

// 返回一张可以随意拉伸不变形的图片，一般用于聊天气泡
+ (UIImage *)imageResizable:(UIEdgeInsets)edgeInsets imageName:(NSString *)name {
    
    return [[UIImage imageNamed:name] resizableImageWithCapInsets:edgeInsets];
}

// 修改本地图片透明度，范围0-1
+ (UIImage *)imageAlpha:(CGFloat)alpha imageName:(NSString *)name {
    
    UIImage *normal = [UIImage imageNamed:name];
    UIGraphicsBeginImageContextWithOptions(normal.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, normal.size.width, normal.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, normal.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// 压缩本地图片质量，newSize：大小超过多少才进行压缩，单位 KB
+ (UIImage *)imageCompress:(NSUInteger)newSize imageName:(NSString *)name {
    
    UIImage *normal = [UIImage imageNamed:name];
    NSData *imageData = UIImageJPEGRepresentation(normal, 1.0);
    if (imageData.length > 1024 * newSize) {
        imageData = UIImageJPEGRepresentation(normal, 1024 * newSize / (CGFloat)imageData.length);
    }
    UIImage *newImage = [UIImage imageWithData:imageData];
    
    return newImage;
}

// 根据颜色创建图片
+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize {
    
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, 0.0f);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
