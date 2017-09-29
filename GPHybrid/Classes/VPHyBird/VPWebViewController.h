//
//  VPWebViewController.h
//  vpGaming
//
//  Created by tortoise on 17/1/5.
//  Copyright © 2017年 weipei. All rights reserved.
//

#import "VPBaseViewController.h"
#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>
#import "VPBaseWebView.h"
#import "VPBaseWKWebView.h"

//提示状态机
typedef enum VPWebOverlayStatus {
    VPWebOverlayStatusSuccess = 1, //加载成功
    VPWebOverlayStatusLoading = 0,    //加载中
    VPWebOverlayStatusError = -1,      //网络错误
    VPWebOverlayStatusReload = 2,     //重新加载
} VPWebOverlayStatus;


@interface VPWebViewController : VPBaseViewController

@property (nonatomic, strong) VPBaseWebView *uiWebView;   //uiwebview视图
@property (nonatomic, strong) VPBaseWKWebView *wkWebView; //wkwebview视图
@property (nonatomic, strong) NSString *titleName;        //外界传入标题(写死)
@property (nonatomic, strong) UIView *baseWebViewOwner;   //webview的父类
@property (nonatomic, strong) UIView *baseWebView;        //webview
@property (nonatomic, strong) UIScrollView *scrollView;   //scrollView

@property (nonatomic, copy) void (^webVLoadingBlock)(VPWebOverlayStatus); //加载结果回调
@property (nonatomic, copy) void (^getWebVTitle)(NSString *);             //加赞成功后,动态获取网页标题
@property (nonatomic, copy) void (^getWebVUrl)(NSString *);               //加赞成功后,动态获取网页Url
@property (nonatomic, copy) void (^breakIntoNativePage)(NSString *);    //跳转到原生页面

@property (assign, nonatomic) BOOL showProgressView; //是否显示进度条，默认为NO

@property (assign, nonatomic) BOOL showHostURl; //是否显示url，默认为NO

@property (assign, nonatomic) BOOL isforceUseoldWebView;    //是否仅使用UIWebView

@property (assign, nonatomic) BOOL isopenCache; //是否开启缓存(目前只支持wkWebView)

@property (assign, nonatomic) BOOL openNewViewController; //是否开启网页里跳转原生(目前只支持wkWebView)

@property (nonatomic, strong) WebViewJavascriptBridge *bridge; //js交互桥接

@property (nonatomic, assign) VPWebOverlayStatus status;       //网页加载状态

@property (nonatomic, strong) NSString *emIcon;               //自定义图片
@property (nonatomic, assign) CGFloat emTitleFont;            //字体大小
@property (nonatomic, assign) NSInteger emTitleBack;          //字体颜色

@property (nonatomic, strong) NSURLRequest *webUrlRequest;      //基础请求地址

/**
 *  加载简单url地址
 *  param:webUrlStr h5字符串地址
 */
- (void)loadWebViewWithUrlStr:(NSString *)webUrlStr;

/**
 *  加载request地址
 *  param:urlRequest h5封装的request请求
 */
- (void)loadWebViewWithUrlRequest:(NSMutableURLRequest *)urlRequest; //加载request

/**
 重定向url
 @param webUrlStr h5字符串地址
 */
- (void)rediRectWebViewWithUrlStr:(NSString *)webUrlStr;

/**
 *   返回上一页
 */
- (void)goBack;

/**
 *   刷新
 */
- (void)refresh;

/**
 缓存图片
 
 @param imgs imgs
 */
- (void)cacheImg:(NSArray *)imgs;

@end
