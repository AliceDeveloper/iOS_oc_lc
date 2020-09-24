//
//  BaseWebViewController.m
//  iOS_OC_lc
//
//  Created by lichun on 2020/9/1.
//  Copyright © 2020 lc. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.url.length > 0) {
        switch (self.webType) {
            case BaseWebType_Online: {
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
                break;
            }
            case BaseWebType_Offline: {
                [self.webView loadFileURL:[NSURL fileURLWithPath:self.url]
                  allowingReadAccessToURL:[NSURL fileURLWithPath:self.url]];
                break;
            }
            case BaseWebType_H5Text: {
                [self.webView loadHTMLString:self.url baseURL:nil];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - SET/GET

- (WKWebView *)webView {
    
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc] init];
        configuration.userContentController = [[WKUserContentController alloc] init];
        [configuration.userContentController addScriptMessageHandler:self name:@"mutual"];
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.userInteractionEnabled = YES;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_webView];
    }
    
    return _webView;
}

- (void)setJs:(NSString *)js {
    
    if (js == nil) {
        return;
    }
    _js = js;
    [self.webView evaluateJavaScript:_js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    }];
}

#pragma mark - <WKScriptMessageHandler>

// 原生接收js调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    // js加载原生方法，规定为window.webkit.messageHandlers.mutual.postMessage({});
    // params 传递的参数，仅能传递一个参数，通常传一个封装好的json对象
}

#pragma mark - <WKNavigationDelegate>

// 1.当Web内容开始在Web视图中加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

// 2.当Web视图开始接收Web内容时调用：navigation包含跟踪网页加载进度的信息
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}

// 3.跳转成功,页面加载完毕时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

// 4.当Web视图的Web内容处理终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
}

// 在导航过程中发生错误时调用，跳转失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
}

// 当Web视图加载内容时发生错误时调用，页面加载失败。没有网络，加载地址，进入的是这个回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error {
}

@end
