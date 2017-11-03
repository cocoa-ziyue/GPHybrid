//
//  VPWebViewController.m
//  vpGaming
//
//  Created by tortoise on 17/1/5.
//  Copyright © 2017年 weipei. All rights reserved.
//

#import "VPWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "GPNavtionBarDefines.h"
#import "extobjc.h"
#import "VPHybridPageLoadView.h"

@interface VPWebViewController () <VPWebViewDelegate, VPWKWebViewDelegate>

@property (nonatomic, strong) NJKWebViewProgressView *progressView; //进度条
@property (nonatomic, strong) UIProgressView *wkProgressView;       //进度条
@property (nonatomic, strong) UIView *webSuperView;
@property (nonatomic, strong) UILabel *hostDeslbl;                 //host名称
@property (assign, nonatomic) BOOL showPageLoadView;              //是否开启转圈
@property (nonatomic, strong) VPHybridPageLoadView *pageLoadView;     //转圈
@property (nonatomic, strong, readwrite) NSString *currentUrl;   //当前请求地址

@end

@implementation VPWebViewController

#pragma mark -
#pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self propertyInit];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.titleName forKey:Nav_Title];
    [params setValue:@"navgation_back_btn" forKey:Nav_Left];
    [self p_setTopTitleDetail:params];
}

- (void)propertyInit {
    self.showHostURl = NO;
    self.showPageLoadView = !self.showProgressView;    //默认开启转圈
    if (self.hiddenAll) {
        self.showPageLoadView = NO;
        self.showProgressView = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.wkProgressView) {
        [self.wkProgressView removeFromSuperview];
        self.wkProgressView = nil;
    }
    if (self.progressView) {
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark - public method complements

- (void)loadWebViewWithUrlStr:(NSString *)webUrlStr {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:webUrlStr]];
    self.webUrlRequest = request;
    if (iOS8LESS || self.isforceUseoldWebView) {
        self.uiWebView.isSpecail = self.isSpecial;
        self.uiWebView.request = request;
        if (!self.uiWebView.superview) {
            [self.view addSubview:self.uiWebView];
        }
    } else {
        self.wkWebView.isopenCache = self.isopenCache;
        self.wkWebView.request = request;
        if (!self.wkWebView.superview) {
            [self.view addSubview:self.wkWebView];
        }
    }
    self.status = VPWebOverlayStatusLoading;
}

- (void)rediRectWebViewWithUrlStr:(NSString *)webUrlStr {
    [self.wkWebView.wkWebView removeObserver:self.wkWebView forKeyPath:@"title"];
    [self.wkWebView.wkWebView removeObserver:self.wkWebView forKeyPath:@"estimatedProgress"];
    self.bridge = nil;
    self.wkWebView.wkWebView = nil;
    self.wkWebView = nil;
    
    self.webSuperView = self.wkWebView.superview;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:webUrlStr]];
    self.webUrlRequest = request;
    if (iOS8LESS || self.isforceUseoldWebView) {
        self.uiWebView.request = request;
        if (!self.webSuperView) {
            [self.view addSubview:self.uiWebView];
        }
    } else {
        self.wkWebView.isopenCache = self.isopenCache;
        self.wkWebView.request = request;
        if (!self.webSuperView) {
            [self.view addSubview:self.wkWebView];
        }
    }
    self.status = VPWebOverlayStatusLoading;
}

- (void)loadWebViewWithUrlRequest:(NSMutableURLRequest *)urlRequest {
    self.webUrlRequest = urlRequest;
    if (iOS8LESS || self.isforceUseoldWebView) {
        self.uiWebView.request = urlRequest;
        if (!self.uiWebView.superview) {
            [self.view addSubview:self.uiWebView];
        }
    } else {
        self.wkWebView.request = urlRequest;
        if (!self.wkWebView.superview) {
            [self.view addSubview:self.wkWebView];
        }
    }
    self.status = VPWebOverlayStatusLoading;
}

- (void)setStatus:(VPWebOverlayStatus )status {
    _status = status;
    switch (status) {
        case VPWebOverlayStatusLoading:
        {
            if (self.showPageLoadView) {       //开启转圈
                self.pageLoadView.loadStatus = VPPageLoadViewStatusActive;
            }
        }
            break;
        case VPWebOverlayStatusSuccess:
        {
            if (self.showPageLoadView) {       //结束转圈
                self.pageLoadView.loadStatus = VPPageLoadViewStatusEnd;
            }
            if (self.showHostURl) {
                [self setUrlDescpritionShow:self.showHostURl];
            } else {
#if defined(CONFIGURATION_Develop) || defined(DEBUG) //内测、debug阶段
                [self setUrlDescpritionShow:YES];
                self.hostDeslbl.hidden = NO;
#endif
            }
        }
            break;
        case VPWebOverlayStatusError:
        {
            if (self.showPageLoadView) {       //结束转圈
                self.pageLoadView.loadStatus = VPPageLoadViewStatusEnd;
            }
        }
            break;
        case VPWebOverlayStatusReload:
        {
            if (self.showPageLoadView) {       //开启转圈
                self.pageLoadView.loadStatus = VPPageLoadViewStatusActive;
            }
        }
            break;
        default:
            break;
    }
}

- (void)setUrlDescpritionShow:(BOOL)flag {
    if (flag) {
        if (!self.webUrlRequest.URL.host) {
            return;
        }
        self.hostDeslbl.text = [NSString stringWithFormat:@"网页由%@提供", self.webUrlRequest.URL.host];
        [_hostDeslbl sizeToFit];
        _hostDeslbl.center = CGPointMake(SCREEN_WIDTH * 0.5, -NavHeight/2-_hostDeslbl.frame.size.height / 2);
        if (iOS8LESS || self.isforceUseoldWebView) {
            [self.uiWebView.uiWebView insertSubview:_hostDeslbl aboveSubview:self.uiWebView.uiWebView.scrollView];
        } else {
            [self.wkWebView.wkWebView insertSubview:_hostDeslbl aboveSubview:self.wkWebView.wkWebView.scrollView];
        }
    }
}

- (NSString *)getbundlePathWithImgName:(NSString *)imgName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSInteger scale = (NSInteger)[UIScreen mainScreen].scale;
    NSString *plistNameNew = [NSString stringWithFormat:@"%@.bundle/%@@%ldx", @"Resources", imgName,(long)scale];
    NSString *path = [bundle pathForResource:plistNameNew ofType:@"png"];
    return path;
}


#pragma mark -
#pragma mark VPWebViewDelegate methods

- (void)webView:(VPBaseWebView *)webView didChangeProgress:(double)estimatedProgress {
    [self.progressView setProgress:estimatedProgress animated:YES];
}

- (void)webView:(VPBaseWebView *)webView loadingStatus:(NSString *)status {
    if ([status isEqualToString:@"0"]) {

    } else if ([status isEqualToString:@"1"]) {
        self.status = VPWebOverlayStatusSuccess;
    } else if ([status isEqualToString:@"-1"]) {
        self.status = VPWebOverlayStatusError;
    }
    if (self.webVLoadingBlock) {
        self.webVLoadingBlock(self.status);
    }
}

- (void)webView:(VPBaseWebView *)webView getWebViewTitle:(NSString *)title {
    if (self.getWebVTitle) {
        self.getWebVTitle(title);
    }
}

- (void)webView:(VPBaseWebView *)webView cunrrentUrl:(NSString *)url {
    self.currentUrl = url;
    if (self.getWebVUrl) {
        self.getWebVUrl(url);
    }
}

#pragma mark -
#pragma mark VPWKWebViewDelegate methods
- (void)wkWebView:(VPBaseWKWebView *)webView getWebViewUrl:(NSString *)url {
    self.currentUrl = url;
    if (self.getWebVUrl) {
        self.getWebVUrl(url);
    }
}

- (void)wkWebView:(VPBaseWKWebView *)webView didChangeProgress:(double)estimatedProgress {
    [self.wkProgressView setProgress:estimatedProgress animated:YES];
    if (estimatedProgress == 1.f) {
        [self.wkProgressView removeFromSuperview];
        self.wkProgressView = nil;
    }
}

- (void)wkWebView:(VPBaseWKWebView *)webView loadingStatus:(NSString *)status {
    if ([status isEqualToString:@"0"]) {
      
    } else if ([status isEqualToString:@"1"]) {
        self.status = VPWebOverlayStatusSuccess;
    } else if ([status isEqualToString:@"-1"]) {
        self.status = VPWebOverlayStatusError;
    }
    if (self.webVLoadingBlock) {
        self.webVLoadingBlock(self.status);
    }
}

- (void)wkWebView:(VPBaseWKWebView *)webView getWebViewTitle:(NSString *)title {
    if (self.getWebVTitle) {
        self.getWebVTitle(title);
    }
}

- (void)openWebViewControllerWithUrl:(NSString *)webViewUrl {
    if (![webViewUrl containsString:@"http"]) {
        return;
    }
    if (self.breakIntoNativePage) {
        self.breakIntoNativePage(webViewUrl);
    }
}

- (void)cacheImg:(NSArray *)imgs {
    [_wkWebView cacheImgResources:imgs];
}

#pragma mark -
#pragma mark DZNEmptyDataSetDelegate methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.status == VPWebOverlayStatusError) {
        if (!self.emIcon || [self.emIcon isEqualToString:@""]) {
            self.emIcon = [self getbundlePathWithImgName:@"vpcommon_nonet_icon"];
        }
    } else {
        return nil;
    }
    return [UIImage imageNamed:self.emIcon];
}


#pragma mark -
#pragma mark Accesstor methods

- (VPHybridPageLoadView *)pageLoadView {
    if (!_pageLoadView) {
        _pageLoadView = [[VPHybridPageLoadView alloc]initInSuperView:self.baseWebViewOwner withframeY:0 updateCiclerViewY:(self.baseWebViewOwner.frame.size.height - SCREEN_HEIGHT)/2];
    }
    return _pageLoadView;
}

- (VPBaseWebView *)uiWebView {
    if (!_uiWebView) {
        _uiWebView = [[VPBaseWebView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,SCREEN_HEIGHT - NavHeight)];
        _uiWebView.backgroundColor = [UIColor whiteColor];
        _uiWebView.delegate = self;
    }
    return _uiWebView;
}

- (VPBaseWKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[VPBaseWKWebView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT- NavHeight)];
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.delegate = self;
        _wkWebView.openNewViewController = self.openNewViewController;
    }
    return _wkWebView;
}

- (UIView *)baseWebView {
    if (iOS8LESS || self.isforceUseoldWebView) {
        _baseWebView = self.uiWebView.uiWebView;
    } else {
        _baseWebView = self.wkWebView.wkWebView;
    }
    return _baseWebView;
}

- (UIView *)baseWebViewOwner {
    if (iOS8LESS || self.isforceUseoldWebView) {
        _baseWebViewOwner = self.uiWebView;
    } else {
        _baseWebViewOwner = self.wkWebView;
    }
    return _baseWebViewOwner;
}

- (WebViewJavascriptBridge *)bridge {
    if (!_bridge) {
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.baseWebView];
        [_bridge setWebViewDelegate:self.baseWebViewOwner];
    }
    return _bridge;
}

- (NJKWebViewProgressView *)progressView {
    if (!_progressView) {
        CGFloat progressBarHeight = 2.f;
        CGRect barFrame = CGRectMake(0, NavHeight - progressBarHeight, SCREEN_WIDTH, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.progressBarView.backgroundColor = NavBgColor;
        _progressView.progressBarView.tintColor = HWColor(50, 135, 255);
        _progressView.hidden = self.showPageLoadView;
        [self.view addSubview:_progressView];
        [self.view bringSubviewToFront:_progressView];
    }
    return _progressView;
}

- (UIProgressView *)wkProgressView {
    if (!_wkProgressView) {
        CGFloat progressBarHeight = 2.f;
        CGRect barFrame = CGRectMake(0, NavHeight - progressBarHeight, SCREEN_WIDTH, progressBarHeight);
        _wkProgressView = [[UIProgressView alloc] initWithFrame:barFrame];
        _wkProgressView.backgroundColor = NavBgColor;
        _wkProgressView.tintColor = HWColor(50, 135, 255);
        _wkProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _wkProgressView.hidden = self.showPageLoadView;
        [self.view addSubview:_wkProgressView];
        [self.view bringSubviewToFront:_wkProgressView];
    }
    return _wkProgressView;
}

- (UILabel *)hostDeslbl {
    if (!_hostDeslbl) {
        _hostDeslbl = [[UILabel alloc]init];
        _hostDeslbl.backgroundColor = [UIColor clearColor];
        _hostDeslbl.textAlignment = NSTextAlignmentCenter;
        _hostDeslbl.font = [UIFont systemFontOfSize:12.0f];
        _hostDeslbl.textColor = [UIColor blackColor];
        _hostDeslbl.hidden = YES;
    }
    return _hostDeslbl;
}

#pragma mark -
#pragma mark private methods
- (void)p_topLeftBtnClick {
    [self goBack];
}

- (void)goBack {
    if (iOS8LESS || self.isforceUseoldWebView) {
        if (self.uiWebView.uiWebView.canGoBack) {
            [self.uiWebView.uiWebView goBack];
            
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        if (self.wkWebView.wkWebView.canGoBack) {
            [self.wkWebView.wkWebView goBack];
            
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)refresh {
    if (iOS8LESS || self.isforceUseoldWebView) {
        [self.uiWebView.uiWebView reload];
    } else {
        [self.wkWebView.wkWebView reload];
    }
}

- (void)dealloc {
    if (iOS8LESS || _isforceUseoldWebView) {
        _uiWebView.delegate = nil;
        _uiWebView = nil;
    } else {
        _wkWebView.delegate = nil;
        _wkWebView = nil;
    }
}

@end
