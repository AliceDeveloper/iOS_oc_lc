//
//  UIPasteboard+LC.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/17.
//  Copyright © 2020 lc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPasteboard (LC)

// 拷贝粘贴文本
+ (void)copyContext:(NSString *)context;
+ (NSString *)pasteContext;

// 拷贝粘贴图片
+ (void)copyImage:(UIImage *)image;
+ (UIImage *)pasteImage;

@end

NS_ASSUME_NONNULL_END
