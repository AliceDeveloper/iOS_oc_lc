//
//  NSDate+LC.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/17.
//  Copyright © 2020 lc. All rights reserved.
//

#import "NSDate+LC.h"

@implementation NSDate (LC)

// 根据年月日时分秒构建 NSDate
+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second {
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

// 时间戳转 NSDate
+ (NSDate *)timestampToDate:(double)timestamp {
    
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

// NSDate 转格式化 NSString
+ (NSString *)dateToString:(NSDate *)date {
    
    if (date == nil) {
        return @"";
    }
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    NSString *string = @"yyyy-MM-dd HH:mm:ss";
    [dateformatter setDateFormat:string];
    
    return [dateformatter stringFromDate:date];
}

// 根据 NSDate 计算年龄
+ (NSInteger)dateToAge:(NSDate *)date {
    
    if (date == nil) {
        return 0;
    }
    
    NSUInteger UFShort = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *birthCom = [[NSCalendar currentCalendar] components:UFShort fromDate:date];
    NSInteger birthYear  = [birthCom year];
    NSInteger birthMonth = [birthCom month];
    NSInteger birthDay   = [birthCom day];
    NSDateComponents *currentCom = [[NSCalendar currentCalendar] components:UFShort fromDate:[NSDate date]];
    NSInteger currentYear  = [currentCom year];
    NSInteger currentMonth = [currentCom month];
    NSInteger currentDay   = [currentCom day];
    NSInteger age = currentYear - birthYear - 1;
    if ((currentMonth > birthMonth) || (currentMonth == birthMonth && currentDay >= birthDay)) {
        age++;
    }
    
    return age;
}

@end
