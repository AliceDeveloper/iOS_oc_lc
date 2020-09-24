//
//  JsonHelper.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import "JsonHelper.h"

@implementation JsonHelper

// 对象转换成 JSON 字符串
+ (NSString *)jsonStringWithObject:(id)object {
    
    NSString *string = nil;
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (data) {
        string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return string;
}

// 对象转换成 JSON 字符串
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return nil;
    }
    
    return dic;
}

@end
