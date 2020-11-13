//
//  SocketServer.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/11/13.
//  Copyright © 2020 lc. All rights reserved.
//

/* 工程中需单独添加 GCDAsyncSocket 第三方库 */
#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

NS_ASSUME_NONNULL_BEGIN

@interface SocketServer : NSObject

// 获取模块单例
+ (instancetype)sharedInstance;
// 开始监听
- (void)startListen;
// 发送数据
- (void)sendData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
