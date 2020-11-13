//
//  SocketServer.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/11/13.
//  Copyright © 2020 lc. All rights reserved.
//

#import "SocketServer.h"

#define SERVER_PORT (22000)

@interface SocketServer () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *serverSocket;
@property (nonatomic, strong) NSMutableArray *clientSockets;

@end

@implementation SocketServer

#pragma mark - SET/GET

- (GCDAsyncSocket *)serverSocket {
    
    if (_serverSocket == nil) {
        _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return _serverSocket;
}

- (NSMutableArray *)clientSockets {
    
    if (_clientSockets == nil) {
        _clientSockets = [NSMutableArray array];
    }
    
    return _clientSockets;
}

#pragma mark - 外部接口

// 获取模块单例
+ (instancetype)sharedInstance {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SocketServer alloc] init];
    });
    
    return instance;
}

// 开始监听
- (void)startListen {
    
    NSError *error = nil;
    [self.serverSocket acceptOnPort:SERVER_PORT error:&error];
    if (error) {
        LCLog(@"----------------开放监听失败----------------");
    } else {
        LCLog(@"----------------开放监听成功----------------");
    }
}

// 发送数据
- (void)sendData:(NSData *)data {
    
    [self.clientSockets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj writeData:data withTimeout:-1 tag:0];
    }];
}

#pragma mark - <GCDAsyncSocketDelegate>

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    
    [self.clientSockets addObject:newSocket];
    LCLog(@"----------------连接客户端成功----------------");
    LCLog(@"客户端地址: %@:%d", newSocket.connectedHost, newSocket.connectedPort);
    [newSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    LCLog(@"----------------接收数据成功----------------");
    NSString *clientStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    LCLog(@"%@", clientStr);
    [self.serverSocket readDataWithTimeout:-1 tag:0];
}

@end
