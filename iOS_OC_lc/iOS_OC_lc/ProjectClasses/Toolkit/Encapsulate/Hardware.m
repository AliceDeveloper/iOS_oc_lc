//
//  Hardware.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import "Hardware.h"
#import <AVFoundation/AVFoundation.h>
#import <sys/utsname.h>

@interface Hardware () {
    BatteryResult _batteryResult;
    NSTimer *_timer;
}

@end

@implementation Hardware

// 获取模块单例
+ (instancetype)sharedInstance {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Hardware alloc] init];
    });
    
    return instance;
}

// 获取屏幕安全区域
+ (UIEdgeInsets)safeAreaInsets {
    
    if (@available(iOS 11.0, *)) {
        return  [[UIApplication sharedApplication] delegate].window.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

// 根据安全区域判断是否是刘海屏
+ (BOOL)isHairScreen {
    
    return [Hardware safeAreaInsets].bottom > 0 ? YES : NO;
}

// 电池监听
// timeInterval 监听时间间隔，范围>=0，时间等于0就是关闭监听，时间大于0就是开始监听 / result 监听返回的结果
- (void)checkBatteryWithInterval:(CGFloat)timeInterval result:(BatteryResult)result {
    
    if (timeInterval < 0) {
        return;
    }
    if (result) {
        _batteryResult = result;
    }
    if (timeInterval > 0) {
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkBattery)
                                                     name:UIDeviceBatteryStateDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkBattery)
                                                     name:UIDeviceBatteryLevelDidChangeNotification
                                                   object:nil];
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                      target:self
                                                    selector:@selector(checkBattery)
                                                    userInfo:nil
                                                     repeats:YES];
        } else {
            [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
        }
    } else {
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIDeviceBatteryStateDidChangeNotification
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIDeviceBatteryLevelDidChangeNotification
                                                      object:nil];
        if ( _timer != nil) {
            [_timer invalidate];
            _timer = nil;
        }
        [self checkBattery];
    }
}

- (void)checkBattery {
    
    if (_batteryResult) {
        _batteryResult([UIDevice currentDevice].batteryLevel, [UIDevice currentDevice].batteryState);
    }
}

// 设置灯的开关：YES 标识开灯，NO 标识关灯
- (void)torchSetting:(BOOL)on {
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode:(on ? AVCaptureTorchModeOn : AVCaptureTorchModeOff)];
            [device unlockForConfiguration];
        }
    }
}

// 越狱检查
- (BOOL)isJailBreak {
    
    NSArray *jailBreakPathArr = @[@"/Applications/Cydia.app",
                                  @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                  @"/bin/bash",
                                  @"/usr/sbin/sshd",
                                  @"/etc/apt"];
    for (int i = 0; i < jailBreakPathArr.count; i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:jailBreakPathArr[i]]) {
            NSLog(@"当前设备为越狱设备,可能存在安全隐患!");
            return YES;
        }
    }
    
    return NO;
}

@end
