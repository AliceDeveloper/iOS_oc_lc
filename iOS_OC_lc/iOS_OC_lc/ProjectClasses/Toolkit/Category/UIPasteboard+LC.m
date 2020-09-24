//
//  UIPasteboard+LC.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/17.
//  Copyright © 2020 lc. All rights reserved.
//

#import "UIPasteboard+LC.h"

@implementation UIPasteboard (LC)

// 拷贝粘贴文本
+ (void)copyContext:(NSString *)context {
    
    [[UIPasteboard generalPasteboard] setString:context];
}

+ (NSString *)pasteContext {
    
    return [[UIPasteboard generalPasteboard] string];
}

// 拷贝粘贴图片
+ (void)copyImage:(UIImage *)image {
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [[UIPasteboard generalPasteboard] setData:imageData forPasteboardType:@"imageCopy"];
}

+ (UIImage *)pasteImage {
    
    NSData *imageData = [[UIPasteboard generalPasteboard] dataForPasteboardType:@"imageCopy"];
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
}

@end
