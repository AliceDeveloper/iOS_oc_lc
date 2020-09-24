//
//  BaseWebViewController.h
//  iOS_OC_lc
//
//  Created by lichun on 2020/9/1.
//  Copyright © 2020 lc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BaseWebType) {
    BaseWebType_Online,     // 在线网页
    BaseWebType_Offline,    // 本地文档
    BaseWebType_H5Text,     // H5文本
};

@interface BaseWebViewController : UIViewController
<WKScriptMessageHandler,
WKNavigationDelegate,
WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BaseWebType webType;
// webType == BaseWebType_Online url = 在线网页链接
// webType == BaseWebType_Offline url = 本地文档路径
// webType == BaseWebType_H5Text url = H5文本
@property (nonatomic, strong) NSString *url;
// 原生调用JS语句
@property (nonatomic, copy) NSString *js;

@end

NS_ASSUME_NONNULL_END
