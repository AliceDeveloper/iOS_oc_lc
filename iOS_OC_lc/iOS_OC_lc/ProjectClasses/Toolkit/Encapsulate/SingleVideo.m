//
//  SingleVideo.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import "SingleVideo.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface SingleVideo () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIViewController *owner;
@property SingleVideoCompletion completion;
@property SingleVideoCancel cancel;

@end

@implementation SingleVideo

// 获取模块单例
+ (instancetype)sharedInstance {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SingleVideo alloc] init];
    });
    
    return instance;
}

// 弹出列表，选择或拍摄
- (void)singleVideoOwner:(UIViewController *)owner
              completion:(SingleVideoCompletion)completion
                  cancel:(SingleVideoCancel)cancel {
    
    _owner = owner;
    _completion = completion;
    _cancel = cancel;
    
    __weak typeof(&*self) weakSelf = self;
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *addVideo = [UIAlertAction
                               actionWithTitle:@"选择"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf addVideo];
    }];
    [alert addAction:addVideo];
    UIAlertAction *takeVideo = [UIAlertAction
                                actionWithTitle:@"拍摄"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takeVideo];
    }];
    [alert addAction:takeVideo];
    UIAlertAction *canc = [UIAlertAction
                           actionWithTitle:@"取消"
                           style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * _Nonnull action) {
        if (weakSelf.cancel) {
            weakSelf.cancel();
        }
    }];
    [alert addAction:canc];
    [_owner presentViewController:alert animated:YES completion:nil];
}

- (void)takeVideo {
    
    // 判断是否支持相机
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"您的设备不支持拍摄功能");
        return;
    }
    // 读取设备授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"相机权限受限,请在设置中启用");
        return;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted == NO) {
                    NSLog(@"已拒绝授权，打开相机失败");
                }
            });
        }];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    // 摄像头上覆盖的视图，可用通过这个视频来自定义拍照或录像界面
    // self.picker.cameraOverlayView = [self createCustomViewForMakeVideo];
    // 摄像头捕获模式
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    // 设置视频质量
    picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
    // 摄像头设备
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    picker.delegate = self;
    [_owner presentViewController:picker animated:YES completion:nil];
}

- (void)addVideo {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"您的设备不支持相册功能");
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    picker.delegate = self;
    picker.navigationBar.tintColor = _owner.navigationController.navigationBar.tintColor;
    picker.navigationBar.barTintColor = _owner.navigationController.navigationBar.barTintColor;
    picker.navigationBar.titleTextAttributes = _owner.navigationController.navigationBar.titleTextAttributes;
    [_owner presentViewController:picker animated:YES completion:nil];
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    __weak typeof(&*self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
            NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
            if (weakSelf.completion) {
                weakSelf.completion(url.path);
            }
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    __weak typeof(&*self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.cancel) {
            weakSelf.cancel();
        }
    }];
}

@end
