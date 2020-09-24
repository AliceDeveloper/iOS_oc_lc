//
//  QRGenerate.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRGenerate : NSObject

// 获取模块单例
+ (instancetype)sharedInstance;
// 生成二维码
- (UIImage *)generateQRCode:(NSString *)source size:(CGSize)size;
// 生成条形码
- (UIImage *)generateBarCode:(NSString *)source size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
