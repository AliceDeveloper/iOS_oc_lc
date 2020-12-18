//
//  QRScanVC.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/9/24.
//  Copyright © 2020 lc. All rights reserved.
//

#import "QRScanVC.h"
#import <AVFoundation/AVFoundation.h>

@interface QRScanVC () <AVCaptureMetadataOutputObjectsDelegate>

// 扫描区域
@property (nonatomic, strong) UIView *scanView;
// 协调输入输出设备以获得数据
@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation QRScanVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.session stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor lc_black] colorWithAlphaComponent:0.5];
    self.scanView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.scanView.backgroundColor = [[UIColor lc_black] colorWithAlphaComponent:0];
    [self.view addSubview:_scanView];
    [self scanWithRect:_scanView.frame];
}

- (void)scanWithRect:(CGRect)scanRect  {
    
    // 判断是否支持相机
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        LCLog(@"您的设备不支持此功能");
        return;
    }
    // 读取设备授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        LCLog(@"相机权限受限,请在设置中启用");
        return;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted == NO) {
                    LCLog(@"已拒绝授权，打开相机失败");
                }
            });
        }];
        return;
    }
    // 获取摄像设备，创建输入流，创建输出流，设置代理在主线程里刷新
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 设置高质量采集率
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[
        // 一种二维码的制式，开发中主要用的这个
        AVMetadataObjectTypeQRCode,
        // 一种二维码的制式，主要用于航空
        AVMetadataObjectTypeAztecCode,
        AVMetadataObjectTypePDF417Code,
        AVMetadataObjectTypeDataMatrixCode,
        // 我国商品主要采用的条形码，必须是12数字，必须获得许可
        AVMetadataObjectTypeEAN13Code,
        // 我国商品主要采用的条形码，必须是7位或8位数字，必须获得许可
        AVMetadataObjectTypeEAN8Code,
        // 据说用于美国部分地区的条码，长度必须是6位或者11位，必须获得许可
        AVMetadataObjectTypeUPCECode,
        // 一种字母和简单的字符共三十九个字符组成的条形码，缺点是生成的条码较大
        AVMetadataObjectTypeCode39Code,
        // 是上面的一种扩展
        AVMetadataObjectTypeCode39Mod43Code,
        // 据听说是Code39升级版
        AVMetadataObjectTypeCode93Code,
        // 包含字母数字所有字符，包含三个表格更好的对数据进行编码，缺点就是生成条码较大
        AVMetadataObjectTypeCode128Code,
        // 类型二进五出码条形码，只支持数字，最长10位
        AVMetadataObjectTypeInterleaved2of5Code,
        // 全球贸易货号，主要用于运输方面的条形码，iOS8以后才支持
        AVMetadataObjectTypeITF14Code];
    // 设置扫描作用区域，原点在屏幕右上角，向下是X轴，向左是Y轴
    CGRect rect = CGRectMake(scanRect.origin.y / self.scanView.bounds.size.height,
                             scanRect.origin.x / self.scanView.bounds.size.width,
                             scanRect.size.height / self.scanView.bounds.size.height,
                             scanRect.size.width / self.scanView.bounds.size.width);
    [output setRectOfInterest:rect];
    // 设置视图捕获区域
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.scanView.layer.bounds;
    [self.scanView.layer insertSublayer:layer atIndex:0];
    // 开始捕获
    [self.session startRunning];
}

#pragma mark - <AVCaptureMetadataOutputObjectsDelegate>

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // 停止捕获
    [self.session stopRunning];
    // 分析扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects.firstObject;
        NSString *result = obj.stringValue ? obj.stringValue : @"暂无扫描结果";
        LCLog(@"%@", result);
    }
}

@end
