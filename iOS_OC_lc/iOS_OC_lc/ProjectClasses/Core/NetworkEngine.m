//
//  NetworkEngine.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import "NetworkEngine.h"

@implementation NetworkEngine

// 获取模块单例
+ (instancetype)sharedInstance {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkEngine alloc] init];
    });
    
    return instance;
}

// 监听网络状态
+ (void)monitorNetworkStatus {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if ([NetworkEngine sharedInstance].delegate && [[NetworkEngine sharedInstance].delegate respondsToSelector:@selector(networkStatus:)]) {
            [[NetworkEngine sharedInstance].delegate networkStatus:status];
        }
    }];
}

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
            failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *m = [NetworkEngine requestHeader:@"application/json;charset=utf-8"];
    [m GET:path parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        [NetworkEngine handleProgress:1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

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
             failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *m = [NetworkEngine requestHeader:@"application/json;charset=utf-8"];
    [m POST:path parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        [NetworkEngine handleProgress:1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 POST 上传文件
 
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
               failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *m = [NetworkEngine requestHeader:@"multipart/form-data"];
    [m POST:path parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData
                                    name:name ? name : @"image"
                                fileName:fileName ? fileName : @"imageName"
                                mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [NetworkEngine handleProgress:1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 内部 API

// 处理网络加载进度
+ (void)handleProgress:(float)progress {
    
    if ([NetworkEngine sharedInstance].delegate && [[NetworkEngine sharedInstance].delegate respondsToSelector:@selector(networkProgress:)]) {
        [[NetworkEngine sharedInstance].delegate networkProgress:progress];
    }
}

// 设置请求头：包含了对客户端的环境描述、客户端想访问的服务器主机地址等信息
+ (AFHTTPSessionManager *)requestHeader:(NSString *)contentType {
    
    // 顶部展示小菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    // 缓存
    [[NSURLCache sharedURLCache] setMemoryCapacity:10 * 1024 * 1024];
    [[NSURLCache sharedURLCache] setDiskCapacity:100 * 1024 * 1024];
    AFHTTPSessionManager *m = [AFHTTPSessionManager manager];
    m.responseSerializer = [AFJSONResponseSerializer serializer];
    m.requestSerializer = [AFJSONRequestSerializer serializer];
    m.requestSerializer.timeoutInterval = 15;
    m.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    [m.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [m.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"Device-Type"];
    [m.requestSerializer setValue:contentType forHTTPHeaderField:@"Content-Type"];
    // 最大并发数
    m.operationQueue.maxConcurrentOperationCount = 5;
    // 请求安全策略
    m.securityPolicy.allowInvalidCertificates = YES;
    return m;
}

@end
