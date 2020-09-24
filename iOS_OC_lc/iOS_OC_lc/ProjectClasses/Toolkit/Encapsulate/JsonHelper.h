//
//  JsonHelper.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JsonHelper : NSObject

// 对象转换成 JSON 字符串
+ (NSString *)jsonStringWithObject:(id)object;
// JSON 字符串转换成字典对象
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
