//
//  SingleImage.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/6/18.
//  Copyright © 2020 lc. All rights reserved.
//

#import "SingleImage.h"
#import <AVFoundation/AVFoundation.h>

@interface SingleImage () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIViewController *owner;
@property SingleImageCompletion completion;
@property SingleImageCancel cancel;

@end

@implementation SingleImage

// 获取模块单例
+ (instancetype)sharedInstance {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SingleImage alloc] init];
    });
    
    return instance;
}

// 弹出列表，选择或拍照
- (void)singleImageOwner:(UIViewController *)owner
              completion:(SingleImageCompletion)completion
                  cancel:(SingleImageCancel)cancel {
    
    _owner = owner;
    _completion = completion;
    _cancel = cancel;
    
    __weak typeof(&*self) weakSelf = self;
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *addPhoto = [UIAlertAction
                               actionWithTitle:@"选择"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf addPhoto];
    }];
    [alert addAction:addPhoto];
    UIAlertAction *takePhoto = [UIAlertAction
                                actionWithTitle:@"拍照"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takePhoto];
    }];
    [alert addAction:takePhoto];
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

- (void)takePhoto {
    
    // 判断是否支持相机
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"您的设备不支持相机功能");
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
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.owner presentViewController:picker animated:YES completion:nil];
}

- (void)addPhoto {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"您的设备不支持相册功能");
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.navigationBar.tintColor = self.owner.navigationController.navigationBar.tintColor;
    picker.navigationBar.barTintColor = self.owner.navigationController.navigationBar.barTintColor;
    picker.navigationBar.titleTextAttributes = self.owner.navigationController.navigationBar.titleTextAttributes;
    [self.owner presentViewController:picker animated:YES completion:nil];
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    __weak typeof(&*self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.completion) {
            weakSelf.completion(image);
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
