//
//  NetworkEngine.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

/* 工程中需单独添加 AFNetworking 第三方库 */
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NetworkEngineDelegate <NSObject>

@optional
// 网络状态：-1 未知网络状态、0 无网络、1 蜂窝数据、2 WIFI
- (void)networkStatus:(NSInteger)status;
// 网络请求进度：0-1
- (void)networkProgress:(CGFloat)progress;

@end

@interface NetworkEngine : NSObject

@property (nonatomic, weak) id <NetworkEngineDelegate> delegate;
// 获取模块单例
+ (instancetype)sharedInstance;
// 监听网络状态
+ (void)monitorNetworkStatus;

#pragma mark - HTTP API

/**
 GET 请求
 
 @param path 服务器路径
 @param params 参数
 @param success 请求成功
 @param failure 请求失败
 */
+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(void (^)(id data))success
            failure:(void (^)(NSError *error))failure;

/**
 POST 请求
 
 @param path 服务器路径
 @param params 参数
 @param success 请求成功
 @param failure 请求失败
 */
+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(void (^)(id data))success
             failure:(void (^)(NSError *error))failure;

/**
 POST 上传图片
 
 @param path 服务器路径
 @param params 参数
 @param fileData 文件数据
 @param name 根据服务器规则来定义
 @param fileName 文件名称
 @param success 上传成功
 @param failure 上传失败
 */
+ (void)uploadWithPath:(NSString *)path
                params:(NSDictionary *)params
              fileData:(NSData *)fileData
                  name:(NSString *)name
              fileName:(NSString *)fileName
               success:(void (^)(id data))success
               failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
