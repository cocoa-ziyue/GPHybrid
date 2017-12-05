//
//  GPBaseWebView.h
//  GPGaming
//
//  Created by shugangpeng on 17/1/5.
//  Copyright © 2017年 sgp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"

@protocol GPWebViewDelegate;

@interface GPBaseWebView : UIView

@property (nonatomic, strong) UIWebView *uiWebView;
@property (nonatomic, strong) NSMutableURLRequest *request; //请求的request
@property (nonatomic, weak) id<GPWebViewDelegate> delegate;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge; //js交互桥接
@property (nonatomic, assign) BOOL showPageLoadView;         //是否开启加载动画
@property (nonatomic, assign) BOOL isSpecail;               //是否开启替换
@property (nonatomic, assign) BOOL openNewViewController;   //开启新vc

- (void)addCookieswithDict:(NSMutableDictionary *)cookiesDict;

@end

@protocol GPWebViewDelegate <NSObject>

@optional


/**
 加载进度
 @param webView webView
 @param estimatedProgress estimatedProgress
 */
- (void)webView:(GPBaseWebView *)webView didChangeProgress:(double)estimatedProgress;

/**
 加载状态
 @param webView webView
 @param status status
 */
- (void)webView:(GPBaseWebView *)webView loadingStatus:(NSString *)status;

/**
 加载网页成功后获取标题
 @param webView webView
 @param title title
 */
- (void)webView:(GPBaseWebView *)webView getWebViewTitle:(NSString *)title;


/**
 当前webView地址
 
 @param webView webView
 @param url url
 */
- (void)webView:(GPBaseWebView *)webView cunrrentUrl:(NSString *)url;

/**
 监听滚动
 @param scrollView scrollView
 */
- (void)webViewDidScroll:(UIScrollView *)scrollView;

@end
