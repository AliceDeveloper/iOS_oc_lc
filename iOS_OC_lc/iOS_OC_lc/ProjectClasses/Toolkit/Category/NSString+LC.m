//
//  NSString+LC.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/17.
//  Copyright © 2020 lc. All rights reserved.
//

#import "NSString+LC.h"

@implementation NSString (LC)

#pragma mark - 路径

// 沙盒路径：程序主路径
+ (NSString *)homeDirectory {
    
    return NSHomeDirectory();
}

// Documents: 最常用的目录，iTunes同步该应用时会同步此文件夹中的内容，适合存储重要数据
+ (NSString *)documentsPath {
    
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}

// Library/PreferencePanes: iTunes同步该应用时会同步此文件夹中的内容，通常保存应用的设置信息
+ (NSString *)preferencePanesPath {
    
    return NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).lastObject;
}

// Library/Caches: iTunes不会同步此文件夹，适合存储体积大，不需要备份的非重要数据
+ (NSString *)cachesPath {
    
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}

// tmp/: iTunes不会同步此文件夹，系统可能在应用没运行时就删除该目录下的文件，所以此目录适合保存应用中的一些临时文件，用完就删除
+ (NSString *)tmpPath {
    
    return NSTemporaryDirectory();
}

#pragma mark - 格式

// 是否包含中文
- (BOOL)isContainChinese {
    
    if (self == nil || self.length <= 0) {
        return NO;
    }
    
    for (int i = 0; i < self.length; i++) {
        unichar ch = [self characterAtIndex:i];
        if (0x4E00 <= ch && ch <= 0x9FA5) {
            return YES;
        }
    }
    
    return NO;
}

// 判断是否为纯数字
- (BOOL)isPureInt {
    
    if (self == nil || self.length <= 0) {
        return NO;
    }
    
    NSInteger val;
    NSScanner *scan = [NSScanner scannerWithString:self];
    
    return [scan scanInteger:&val] && [scan isAtEnd];
}

// 判断是否为11位手机号码
- (BOOL)isPhoneNumber {
    
    if (self == nil || self.length != 11 || [self isPureInt] == NO || [self hasPrefix:@"1"] == NO) {
        return NO;
    } else {
        return YES;
    }
}

// 判断是否是邮箱格式
- (BOOL)isEmail {
    
    if (self == nil || self.length <= 0) {
        return NO;
    }
    
    NSString *regex = @"[A-Za-z0-9.]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [predicate evaluateWithObject:self];
}

// 判断密码正则 6-20位，大写+小写+数字
- (BOOL)isPassword {
    
    return [self isPasswordWithLengthMin:6 lengthMax:20 regex:LCPasswordRegex_Default];
}

// 判断密码正则，min最少多少位，max最大多少位，regex正则判断规则模板
- (BOOL)isPasswordWithLengthMin:(NSUInteger)min lengthMax:(NSUInteger)max regex:(LCPasswordRegex)regex {
    
    if (self == nil || self.length <= 0) {
        return NO;
    }
    
    NSString *regexStr = [NSString stringWithFormat:@"^[0-9A-Za-z]{%lu,%lu}+$", (unsigned long)min, (unsigned long)max];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    BOOL ret = [predicate evaluateWithObject:self];
    if (ret == YES) {
        // 符合数字条件的有几个字元
        NSRegularExpression *numRX = [NSRegularExpression regularExpressionWithPattern:@"[0-9]"
                                                                               options:0
                                                                                 error:nil];
        NSInteger numCount = [numRX numberOfMatchesInString:self
                                                    options:NSMatchingReportProgress
                                                      range:NSMakeRange(0, self.length)];
        // 符合大写字母条件的有几个字元
        NSRegularExpression *bRx = [NSRegularExpression regularExpressionWithPattern:@"[A-Z]"
                                                                             options:0
                                                                               error:nil];
        NSInteger bCount = [bRx numberOfMatchesInString:self
                                                options:NSMatchingReportProgress
                                                  range:NSMakeRange(0, self.length)];
        // 符合小写字母条件的有几个字元
        NSRegularExpression *sRx = [NSRegularExpression regularExpressionWithPattern:@"[a-z]"
                                                                             options:0
                                                                               error:nil];
        NSInteger sCount = [sRx numberOfMatchesInString:self
                                                options:NSMatchingReportProgress
                                                  range:NSMakeRange(0, self.length)];
        switch (regex) {
            case LCPasswordRegex_Default:
                ret = (numCount > 0 && bCount > 0 && sCount > 0) ? YES : NO;
                break;
            case LCPasswordRegex_Light:
                ret = (numCount > 0 && (bCount + sCount > 0)) ? YES : NO;
                break;
            default:
                ret = NO;
                break;
        }
    }
    
    return ret;
}

#pragma mark - base64编码解码

/*
 UTF-8是一种数据存储格式
 base64是一种传输字节码的编码方式
 */
// base64编码
- (NSString *)base64Encode {
    
    if (self == nil || self.length <= 0) {
        return nil;
    }
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

// base64解码
- (NSString *)base64Decode {
    
    if (self == nil || self.length <= 0) {
        return nil;
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
