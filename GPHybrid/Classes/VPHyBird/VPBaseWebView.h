//
//  VPBaseWebView.h
//  vpGaming
//
//  Created by shugangpeng on 17/1/5.
//  Copyright © 2017年 weipei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"

@protocol VPWebViewDelegate;

@interface VPBaseWebView : UIView

@property (nonatomic, strong) UIWebView *uiWebView;
@property (nonatomic, strong) NSMutableURLRequest *request; //请求的request
@property (nonatomic, weak) id<VPWebViewDelegate> delegate;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge; //js交互桥接
@property (nonatomic, assign) BOOL showPageLoadView;         //是否开启加载动画
@end

@protocol VPWebViewDelegate <NSObject>

@optional


/**
 加载进度
 @param webView webView
 @param estimatedProgress estimatedProgress
 */
- (void)webView:(VPBaseWebView *)webView didChangeProgress:(double)estimatedProgress;

/**
 加载状态
 @param webView webView
 @param status status
 */
- (void)webView:(VPBaseWebView *)webView loadingStatus:(NSString *)status;

/**
 加载网页成功后获取标题
 @param webView webView
 @param title title
 */
- (void)webView:(VPBaseWebView *)webView getWebViewTitle:(NSString *)title;


/**
 当前webView地址
 
 @param webView webView
 @param url url
 */
- (void)webView:(VPBaseWebView *)webView cunrrentUrl:(NSString *)url;

/**
 监听滚动
 @param scrollView scrollView
 */
- (void)webViewDidScroll:(UIScrollView *)scrollView;

@end
