//
//  SocketEngine.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/11/5.
//  Copyright © 2020 lc. All rights reserved.
//

/* 工程中需单独添加 GCDAsyncSocket 第三方库 */
#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

NS_ASSUME_NONNULL_BEGIN

@interface SocketEngine : NSObject

// 获取模块单例
+ (instancetype)sharedInstance;
// 连接服务器
- (void)connectServer;
// 断开连接服务器
- (void)disconnectServer;
// 发送数据
- (void)sendData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
