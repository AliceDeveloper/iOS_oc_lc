//
//  NSDate+LC.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/17.
//  Copyright © 2020 lc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (LC)

// 根据年月日时分秒构建 NSDate
+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second;
// 时间戳转 NSDate
+ (NSDate *)timestampToDate:(double)timestamp;
// NSDate 转格式化 NSString
+ (NSString *)dateToString:(NSDate *)date;
// 根据 NSDate 计算年龄
+ (NSInteger)dateToAge:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
