//
//  SocketEngine.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/11/5.
//  Copyright © 2020 lc. All rights reserved.
//

#import "SocketEngine.h"

#define IP @"192.168.4.42"
#define PORT (22000)

@interface SocketEngine () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *clientSocket; // socket实例
@property (nonatomic, strong) dispatch_source_t beatTimer;  // 心跳定时器

@end

@implementation SocketEngine

#pragma mark - SET/GET

- (GCDAsyncSocket *)clientSocket {
    
    if (_clientSocket == nil) {
        _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return _clientSocket;
}

- (dispatch_source_t)beatTimer {
    
    __weak typeof(self) weakSelf = self;
    if (_beatTimer == nil) {
        _beatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_beatTimer, DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_beatTimer, ^{
            LCLog(@"----------------发送了心跳,轮询发送数据----------------");
            if (weakSelf.clientSocket.isConnected == NO) {
                [weakSelf connectServer];
            }
            NSData *data = [@"我是iOS心跳" dataUsingEncoding:NSUTF8StringEncoding];
            [weakSelf.clientSocket writeData:data withTimeout:-1 tag:0];
        });
    }
    
    return _beatTimer;
}

#pragma mark - 外部接口

// 获取模块单例
+ (instancetype)sharedInstance {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SocketEngine alloc] init];
    });
    
    return instance;
}

// 连接服务器
- (void)connectServer {
    
    NSError *err = nil;
    [self.clientSocket connectToHost:IP onPort:PORT error:&err];
    if (err) {
        LCLog(@"----------------连接服务器失败----------------");
    } else {
        LCLog(@"----------------连接服务器成功----------------");
    }
}

// 断开连接服务器
- (void)disconnectServer {
    
    [self.clientSocket disconnect];
    self.clientSocket.delegate = nil;
    self.clientSocket = nil;
    // 关闭心跳
    dispatch_source_cancel(self.beatTimer);
}

// 发送数据
- (void)sendData:(NSData *)data {
    
    [self.clientSocket writeData:data withTimeout:- 1 tag:0];
}

#pragma mark - <GCDAsyncSocketDelegate>

- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port {
    
    LCLog(@"----------------连接服务器成功----------------");
    LCLog(@"%@", [NSString stringWithFormat:@"%@:%d", host, port]);
    // 发送心跳
    dispatch_resume(self.beatTimer);
    // 读取服务器端的数据
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
    if (err) {
        LCLog(@"----------------连接服务器失败----------------");
        // 自动重连
//        [self connectServer];
    } else {
        LCLog(@"----------------断开服务器成功----------------");
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
    LCLog(@"----------------发送数据成功----------------");
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    LCLog(@"----------------接收数据成功----------------");
    NSString *serverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    LCLog(@"%@", serverStr);
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

@end
