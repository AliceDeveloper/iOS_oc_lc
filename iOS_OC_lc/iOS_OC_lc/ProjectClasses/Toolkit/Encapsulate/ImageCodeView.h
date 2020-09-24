//
//  ImageCodeView.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/9/3.
//  Copyright © 2020 lc. All rights reserved.
//

/* 随机生成图片验证码，默认4位 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ImageCodeType) {
    ImageCodeType_Default,  // 默认字母+数字
    ImageCodeType_Number,   // 数字
    ImageCodeType_Letter,   // 字母
};

@interface ImageCodeView : UIView

// 图片验证码生成回调
@property (nonatomic, assign) void(^imageCodeBlock)(NSString *imageCode);

// 初始化视图
- (instancetype)initWithFrame:(CGRect)frame type:(ImageCodeType)type;
// 刷新图片验证码
- (void)refreshImageCode;

@end

NS_ASSUME_NONNULL_END
