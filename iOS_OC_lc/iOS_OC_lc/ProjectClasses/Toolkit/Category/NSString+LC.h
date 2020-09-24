//
//  NSString+LC.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/17.
//  Copyright © 2020 lc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LCPasswordRegex) {
    LCPasswordRegex_Default,   // 大小字母+小写字母+数字
    LCPasswordRegex_Light,     // 字母+数字
};

@interface NSString (LC)

#pragma mark - 路径

// 沙盒路径：程序主路径
+ (NSString *)homeDirectory;
// Documents: 最常用的目录，iTunes同步该应用时会同步此文件夹中的内容，适合存储重要数据
+ (NSString *)documentsPath;
// Library/PreferencePanes: iTunes同步该应用时会同步此文件夹中的内容，通常保存应用的设置信息
+ (NSString *)preferencePanesPath;
// Library/Caches: iTunes不会同步此文件夹，适合存储体积大，不需要备份的非重要数据
+ (NSString *)cachesPath;
// tmp/: iTunes不会同步此文件夹，系统可能在应用没运行时就删除该目录下的文件，所以此目录适合保存应用中的一些临时文件，用完就删除
+ (NSString *)tmpPath;

#pragma mark - 格式

// 是否包含中文
- (BOOL)isContainChinese;
// 判断是否为纯数字
- (BOOL)isPureInt;
// 判断是否为11位手机号码
- (BOOL)isPhoneNumber;
// 判断是否是邮箱格式
- (BOOL)isEmail;
// 判断密码正则 6-20位，大写+小写+数字
- (BOOL)isPassword;
// 判断密码正则，min最少多少位，max最大多少位，regex正则判断规则模板
- (BOOL)isPasswordWithLengthMin:(NSUInteger)min lengthMax:(NSUInteger)max regex:(LCPasswordRegex)regex;

#pragma mark - base64编码解码

/*
 UTF-8是一种数据存储格式
 base64是一种传输字节码的编码方式
 */
// base64编码
- (NSString *)base64Encode;
// base64解码
- (NSString *)base64Decode;

@end

NS_ASSUME_NONNULL_END
