//
//  Hardware.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Hardware : NSObject

// 获取模块单例
+ (instancetype)sharedInstance;
// 获取屏幕安全区域
+ (UIEdgeInsets)safeAreaInsets;
// 根据安全区域判断是否是刘海屏
+ (BOOL)isHairScreen;

// 电池监听返回结果 Block
// batteryLevel 电量0-1 / batteryState 电池状态
typedef void (^BatteryResult)(CGFloat batteryLevel, NSInteger batteryState);
// 电池监听
// timeInterval 监听时间间隔，范围>=0，时间等于0就是关闭监听，时间大于0就是开始监听 / result 监听返回的结果
- (void)checkBatteryWithInterval:(CGFloat)timeInterval result:(BatteryResult)result;

// 设置灯的开关 on YES 标识开灯，NO 标识关灯
- (void)torchSetting:(BOOL)on;

// 越狱检查
- (BOOL)isJailBreak;

@end

NS_ASSUME_NONNULL_END
