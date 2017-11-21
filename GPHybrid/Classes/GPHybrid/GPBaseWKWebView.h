//
//  GPBaseWKWebview.h
//  GPGaming
//
//  Created by shugangpeng on 2017/2/8.
//  Copyright © 2017年 weipei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"

@protocol GPWKWebViewDelegate;


@interface GPBaseWKWebView : UIView

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) NSMutableURLRequest *request; //请求的request
@property (nonatomic, weak) id<GPWKWebViewDelegate> delegate;
@property (nonatomic, assign) BOOL isopenCache;                //是否开启缓存
@property (nonatomic, assign) BOOL isForceRefresh;             //是否网页刷新，出现刷新则不走缓存
@property (nonatomic, assign) BOOL openNewViewController;      //开启新vc
@property (nonatomic, assign) BOOL showPageLoadView;           //是否开启加载动画
@property (nonatomic, strong) WebViewJavascriptBridge *bridge; //js交互桥接
/**
 缓存图片到沙盒
 
 @param imgArr imgArr
 */
- (void)cacheImgResources:(NSArray *)imgArr;

@end

@protocol GPWKWebViewDelegate <NSObject>

@optional


/**
 监听网页加载进度
 @param webView webView
 @param estimatedProgress estimatedProgress
 */
- (void)wkWebView:(GPBaseWKWebView *)webView didChangeProgress:(double)estimatedProgress;

/**
 监听网页加载状态成功或失败
 @param webView webView
 @param status status (1,成功，-1,失败)
 */
- (void)wkWebView:(GPBaseWKWebView *)webView loadingStatus:(NSString *)status;

/**
 异步获取网页URl
 
 @param webView webView
 @param title title
 */
- (void)wkWebView:(GPBaseWKWebView *)webView getWebViewUrl:(NSString *)url;
/**
 异步获取网页标题
 
 @param webView webView
 @param title title
 */
- (void)wkWebView:(GPBaseWKWebView *)webView getWebViewTitle:(NSString *)title;

/**
 监听网页滚动
 @param scrollView scrollView
 */
- (void)wkWebViewDidScroll:(UIScrollView *)scrollView;

/**
 重开网页
 
 @param webViewUrl webViewUrl
 */
- (void)openWebViewControllerWithUrl:(NSString *)webViewUrl;

@end
