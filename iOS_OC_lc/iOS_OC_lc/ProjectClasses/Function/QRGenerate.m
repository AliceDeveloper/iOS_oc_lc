//
//  QRGenerate.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import "QRGenerate.h"

@implementation QRGenerate

// 获取模块单例
+ (instancetype)sharedInstance {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QRGenerate alloc] init];
    });
    
    return instance;
}

// 生成二维码
- (UIImage *)generateQRCode:(NSString *)source size:(CGSize)size {
    
    // 参数判断
    if (source == nil || CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    
    NSData *data = [source dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    
    return [self resizeCodeImage:filter.outputImage withSize:size];
}

// 生成条形码
- (UIImage *)generateBarCode:(NSString *)source size:(CGSize)size {
    
    // 参数判断
    if (source == nil || CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    
    NSData *data = [source dataUsingEncoding:NSASCIIStringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    // 设置生成的条形码的上，下，左，右的margins的值
    [filter setValue:@(0) forKey:@"inputQuietSpace"];
    
    return [self resizeCodeImage:filter.outputImage withSize:size];
}

- (UIImage *)resizeCodeImage:(CIImage *)image withSize:(CGSize)size {
    
    if (image) {
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scaleWidth = size.width / CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height / CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        CGContextRelease(contentRef);
        CGImageRelease(imageRef);
        return [UIImage imageWithCGImage:imageRefResized];
    } else {
        return nil;
    }
}

@end
