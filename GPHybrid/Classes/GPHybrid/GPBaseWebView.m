//
//  GPBaseWebView.m
//  GPGaming
//
//  Created by shugangpeng on 17/1/5.
//  Copyright © 2017年 sgp. All rights reserved.
//

#import "GPBaseWebView.h"
#import "NJKWebViewProgress.h"
#import "Masonry.h"

@interface GPBaseWebView () <UIWebViewDelegate, NJKWebViewProgressDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
//@property (nonatomic, strong) NoDataView *errorView;
//@property (nonatomic, strong) GPPageLoadView *pageLoadView;
@property (nonatomic, strong) NSString *domainUrl;

@end


@implementation GPBaseWebView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.uiWebView];
        self.uiWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight);
        self.progressProxy = [[NJKWebViewProgress alloc] init];
        self.progressProxy.webViewProxyDelegate = self;
        self.progressProxy.progressDelegate = self;
        self.uiWebView.delegate = self.progressProxy;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidDisappear {
    [self.uiWebView stopLoading];
    [self.uiWebView removeFromSuperview];
}

- (void)addCookieswithDict:(NSMutableDictionary *)cookiesDict {
    //清除cookies
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
    self.domainUrl = [NSString stringWithFormat:@"%@",[cookiesDict valueForKey:@"Domain"]];
    //遍历keys
    for (NSString *keyStr in cookiesDict.allKeys) {
        NSString *valueStr = [NSString stringWithFormat:@"%@",[cookiesDict valueForKey:keyStr]];
        [self addCookieWithDict:@{keyStr:valueStr}];
    }
}

- (void)addCookieWithDict:(NSDictionary *)dict {
    NSMutableDictionary *cookiePropertiesLang = [NSMutableDictionary dictionary];
    [cookiePropertiesLang setObject:dict.allKeys[0] forKey:NSHTTPCookieName];
    [cookiePropertiesLang setObject:dict.allValues[0] forKey:NSHTTPCookieValue];
    [cookiePropertiesLang setObject:@"/" forKey:NSHTTPCookiePath];
    [cookiePropertiesLang setObject:self.domainUrl forKey:NSHTTPCookieDomain];
    [cookiePropertiesLang setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookiePropertiesLang setObject:@"0" forKey:NSHTTPCookieDiscard];
    NSHTTPCookie *cookieuser = [[NSHTTPCookie alloc]initWithProperties:cookiePropertiesLang];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
}


#pragma mark -
#pragma mark Accessor methods

//- (void)refreshAction:(UITapGestureRecognizer *)recognizer {
//    self.errorView.hidden = YES;
//    self.pageLoadView.loadStatus = GPPageLoadViewStatusActive;
//    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
//    dispatch_after(timer, dispatch_get_main_queue(), ^{
//        [self setRequest:_request];
//    });
//}

- (void)setRequest:(NSMutableURLRequest *)request {
    _request = request;
    NSString *app_versions = [NSString stringWithFormat:@"ios%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];

    [_request setValue:app_versions forHTTPHeaderField:@"app-versions"];
    [self.uiWebView loadRequest:_request];
    NSLog(@"UIWebView: web url is %@", _request.URL.absoluteString);
}


- (UIWebView *)uiWebView {
    if (!_uiWebView) {
        _uiWebView = [[UIWebView alloc] init];
        _uiWebView.backgroundColor = [UIColor whiteColor];
        _uiWebView.delegate = self;
        _uiWebView.scrollView.delegate = self;
        _uiWebView.scalesPageToFit = YES;
        _uiWebView.dataDetectorTypes = UIDataDetectorTypeAll;
        _uiWebView.opaque = NO;
    }
    return _uiWebView;
}

//- (GPPageLoadView *)pageLoadView {
//    if (!_pageLoadView) {
//        _pageLoadView = [[GPPageLoadView alloc]initInSuperView:self withframeY:0 updateCiclerViewY:(self.frame.size.height - SCREEN_HEIGHT)/2];
//    }
//    return _pageLoadView;
//}

//- (NoDataView *)errorView {
//    if (!_errorView) {
//        _errorView = [[NoDataView alloc] initWithFrame:self.uiWebView.frame];
//        _errorView.logoImage.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshAction:) ];
//        [_errorView.logoImage addGestureRecognizer:tap];
//        _errorView.errorType = 1;
//        [_errorView noDataTitle:GPLocalizedStringFromModule(@"网络不给力,请检查网络或点击屏幕刷新", kVPCommonLocalized)];
//    }
//    return _errorView;
//}

- (WebViewJavascriptBridge *)bridge {
    if (!_bridge) {
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.uiWebView];
        [_bridge setWebViewDelegate:self];
    }
    return _bridge;
}

#pragma mark -
#pragma mark UIWebViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(webViewDidScroll:)]) {
        [self.delegate webViewDidScroll:self.uiWebView.scrollView];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([self.delegate respondsToSelector:@selector(webView:loadingStatus:)]) {
        [self.delegate webView:self loadingStatus:@"0"]; //开始加载
    }
    if(self.showPageLoadView){
//        self.pageLoadView.loadStatus = GPPageLoadViewStatusActive;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //需要替换,则开启替换
    if (self.isSpecail) {
        NSString *topstr = @"document.getElementsByClassName('tophead')[0].remove();";
        [webView stringByEvaluatingJavaScriptFromString:topstr];
        NSString *sharestr = @"document.getElementById('soshm').remove();";
        [webView stringByEvaluatingJavaScriptFromString:sharestr];
        NSString *SOHUCSstr = @"document.getElementById('SOHUCS').remove();";
        [webView stringByEvaluatingJavaScriptFromString:SOHUCSstr];
        NSString *footerstr = @"document.getElementsByClassName('footer')[0].remove();";
        [webView stringByEvaluatingJavaScriptFromString:footerstr];
        NSString *khdbox = @"document.getElementsByClassName('khdbox')[0].remove();";
        [webView stringByEvaluatingJavaScriptFromString:khdbox];
        NSString *newsbox = @"document.getElementsByClassName('newsbox')[0].remove();";
        [webView stringByEvaluatingJavaScriptFromString:newsbox];
    }
    if(self.showPageLoadView){
//        self.pageLoadView.loadStatus = GPPageLoadViewStatusEnd;
    }
    NSString *webTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([self.delegate respondsToSelector:@selector(webView:getWebViewTitle:)]) {
        [self.delegate webView:self getWebViewTitle:webTitle]; //加载完毕，获取标题
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(webView:loadingStatus:)]) {
            [self.delegate webView:self loadingStatus:@"1"]; //加载完毕
        }
    });
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(webView:loadingStatus:)]) {
        [self.delegate webView:self loadingStatus:@"-1"]; //加载失败
    }
//    if(self.showPageLoadView){
//        self.pageLoadView.loadStatus = GPPageLoadViewStatusEnd;
//        [self addSubview:self.errorView];
//        self.errorView.logoImage.centerY = self.errorView.height - self.errorView.logoImage.height/2;
//        self.errorView.hidden = NO;
//    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *currentUrl = request.URL.absoluteString;
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:cunrrentUrl:)]) {
        [self.delegate webView:self cunrrentUrl:currentUrl];
    }
    if(!self.openNewViewController || [currentUrl isEqualToString:_request.URL.absoluteString] || ![currentUrl containsString:@"bilibili"]) {  //主页面加载内容
         return YES;   //允许跳转
    } else {
        return NO;     //不允许跳转
    }
    return YES;
}

#pragma mark -
#pragma mark NJKWebViewProgressDelegate methods

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    if ([self.delegate respondsToSelector:@selector(webView:didChangeProgress:)]) {
        [self.delegate webView:self didChangeProgress:progress];
    }
}

- (void)dealloc {
    _uiWebView.scrollView.delegate = nil;
}

@end
