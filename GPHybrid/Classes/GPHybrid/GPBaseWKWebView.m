//
//  GPBaseWKWebview.m
//  GPGaming
//
//  Created by shugangpeng on 2017/2/8.
//  Copyright © 2017年 sgp. All rights reserved.
//

#import "GPBaseWKWebView.h"
#import "NJKWebViewProgress.h"
#import "GPHybridPageLoadView.h"
#import "NSString+Hybridmd5.h"
#import <AFNetworking/AFImageDownloader.h>

@interface GPBaseWKWebView () <WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *h5orignContent;
@property (nonatomic, strong) NSString *documentPath;
//@property (nonatomic, strong) NoDataView *errorView;
@property (nonatomic, strong) GPHybridPageLoadView *pageLoadView;
@property (nonatomic, assign) BOOL loadSuccess;

@end


@implementation GPBaseWKWebView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.wkWebView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - loadRequest methods

- (void)setRequest:(NSMutableURLRequest *)request {
    _request = request;
    NSString *app_versions = [NSString stringWithFormat:@"ios%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [_request setValue:app_versions forHTTPHeaderField:@"app-versions"];
    if (self.isForceRefresh) { //发生了网页刷新，则请求网页
        [self.wkWebView loadRequest:_request];
        return;
    }
    if (self.isopenCache) {                           //若开启缓存，则先读取本地
        if (![self isFileExists:self.documentPath]) { //不存在缓存文件
            [self.wkWebView loadRequest:request];
            [self cacheH5Code];
        } else {    //存在则读缓存的html
            NSURL *baseUrl = [NSURL fileURLWithPath:[self cachePach]];
            NSString *htmlString = [NSString stringWithContentsOfFile:self.documentPath encoding:NSUTF8StringEncoding error:nil];
            [self.wkWebView loadHTMLString:htmlString baseURL:baseUrl];
        }
    } else {        //反之，则请求网页
        [self.wkWebView loadRequest:_request];
    }
    NSLog(@"WKWebView: web url is %@", _request.URL.absoluteString);
    
    if (self.showPageLoadView) {
        self.pageLoadView.loadStatus = GPPageLoadViewStatusActive;
    }
}


#pragma mark - WKNavigationDelegate delegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.activityIndicator startAnimating];
    if ([self.delegate respondsToSelector:@selector(wkWebView:loadingStatus:)]) {
        [self.delegate wkWebView:self loadingStatus:@"0"];
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.activityIndicator stopAnimating];
    self.loadSuccess = YES;
    if ([self.delegate respondsToSelector:@selector(wkWebView:loadingStatus:)]) {
        [self.delegate wkWebView:self loadingStatus:@"1"];
    }
    if(self.showPageLoadView){
        self.pageLoadView.loadStatus = GPPageLoadViewStatusEnd;
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    [self.activityIndicator stopAnimating];
    if ([self.delegate respondsToSelector:@selector(wkWebView:loadingStatus:)]) {
        [self.delegate wkWebView:self loadingStatus:@"-1"];
    }
    if(self.showPageLoadView){
        self.pageLoadView.loadStatus = GPPageLoadViewStatusEnd;
    }
}

// 处理页面跳转
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    if ([self.delegate respondsToSelector:@selector(wkWebView:getWebViewUrl:)]) {
        [self.delegate wkWebView:self getWebViewUrl:navigationAction.request.URL.absoluteString];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(!self.openNewViewController || [strRequest isEqualToString:_request.URL.absoluteString]) {  //主页面加载内容
        decisionHandler(WKNavigationActionPolicyAllow);     //允许跳转
    } else {    //截获页面里面的链接点击
        //do something you want
        if ([self.delegate respondsToSelector:@selector(openWebViewControllerWithUrl:)] && self.loadSuccess) {
            if ([self urlValidation:navigationAction.request.URL.absoluteString]) {
                [self.delegate openWebViewControllerWithUrl:navigationAction.request.URL.absoluteString];
            }
            decisionHandler(WKNavigationActionPolicyCancel);    //不允许跳转
            return;
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 在代理方法中处理对应事件
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"%@", message.body);
}

#pragma mark -
#pragma mark private methods

- (BOOL)urlValidation:(NSString *)string {
    NSError *error;
    // 正则1
    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString * substringForMatch = [string substringWithRange:match.range];
        NSLog(@"匹配到了新地址%@",substringForMatch);
        return YES;
    }
    return NO;
}

- (void)refreshAction:(UITapGestureRecognizer *)recognizer {
    //    self.errorView.hidden = YES;
    //    self.pageLoadView.loadStatus = GPPageLoadViewStatusActive;
    //    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    //    dispatch_after(timer, dispatch_get_main_queue(), ^{
    //            [self setRequest:_request];
    //    });
}

- (void)cacheH5Code {
    //缓存Html
    NSError *error = nil;
    NSString *htmlStr = [NSString stringWithContentsOfURL:_request.URL encoding:NSUTF8StringEncoding error:nil];
    //创建缓存路径
    BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:[self cachePach]
                                            withIntermediateDirectories:YES
                                                             attributes:nil
                                                                  error:&error];
    if (result) {
        NSError *writeError = nil;
        BOOL writeResult = [htmlStr writeToFile:self.documentPath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
        if (!writeResult) {
            NSLog(@"write html error is %@", writeError);
            return;
        }
    }
}

- (void)cacheImgResources:(NSArray *)imgArr {
    if (!self.isopenCache) { //未开启缓存
        return;
    }
    if (!imgArr || imgArr.count == 0) { //图片数组为空
        return;
    }
    if (![imgArr[0] containsString:@"http"]) { //非服务端图片，返回
        return;
    }
    
    NSString *firstImgPath = [[self cachePach] stringByAppendingPathComponent:[NSString GP_hybrid_md5:imgArr[0]]];
    
    BOOL diskFlag = [self isFileExists:firstImgPath];
    if (diskFlag) {
        return;
    }
    
    __block NSUInteger count = 0;
    __block NSMutableArray *imgUrlArr = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < imgArr.count; i++) {
        NSString *imgUrl = imgArr[i];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl]];
        [[AFImageDownloader defaultInstance] downloadImageForURLRequest:request success:^(NSURLRequest *_Nonnull request, NSHTTPURLResponse *_Nullable response, UIImage *_Nonnull responseObject) {
            NSData *data = UIImageJPEGRepresentation(responseObject, 0.5);
            NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@", [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
            NSString *localPath = [[self cachePach] stringByAppendingPathComponent:[NSString GP_hybrid_md5:imgUrl]];
            if (![data writeToFile:localPath atomically:NO]) {
                NSLog(@"写入本地失败：%@", imgUrl);
                return;
            } else {
                count++;
                [imgUrlArr addObject:imageSource];
                if (count == imgArr.count) {
                    [self replaceH5ContentWithArr:imgUrlArr];
                }
            }
        } failure:^(NSURLRequest *_Nonnull request, NSHTTPURLResponse *_Nullable response, NSError *_Nonnull error) {
            NSLog(@"download image url fail: %@", error);
        }];
    }
}

- (void)replaceH5ContentWithArr:(NSMutableArray *)imgUrlArr {
    for (NSString *imageURL in imgUrlArr) {
        /****** 正则替换img src *****/
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img[^>]+src=\")([^\"]+)" options:0 error:nil];
        NSArray<NSTextCheckingResult *> *arr = [regex matchesInString:self.h5orignContent options:0 range:NSMakeRange(0, self.h5orignContent.length)];
        for (int i = 0; i <= arr.count - 1; i++) {
            NSTextCheckingResult *result = arr[i];
            NSString *str = [self.h5orignContent substringWithRange:result.range];
            NSArray *arr = [str componentsSeparatedByString:@"src=\""];
            if (arr.count <= 1) {
                continue;
            }
            NSString *httpString = arr.lastObject;
            NSString *imgString = arr.firstObject;
            if (![_h5orignContent containsString:httpString]) {
                continue;
            }
            if ([httpString containsString:@"http"] && [imgString containsString:@"img alt"]) {
                NSRange range = [_h5orignContent rangeOfString:httpString];
                if (range.location && range.length) {
                    _h5orignContent = [_h5orignContent stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%@", imageURL]];
                }
            }
        }
    }
    NSError *writeError = nil;
    BOOL writeResult = [_h5orignContent writeToFile:self.documentPath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    if (!writeResult) {
        NSLog(@"write html error is %@", writeError);
        return;
    }
}

//获取缓存路径
- (NSString *)cachePach {
    //Get documents directory
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = [directoryPaths objectAtIndex:0];
    NSString *GPFileCachePath = [NSString stringWithFormat:@"%@/GPCache", documentDirectoryPath];
    NSString *GPWebFileCache = [NSString stringWithFormat:@"%@/WebFile/", GPFileCachePath];
    return GPWebFileCache;
}

//判断是否存在
- (BOOL)isFileExists:(NSString *)documentUrl {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:documentUrl];
}

#pragma mark -
#pragma mark Accesstor methods

//转圈
- (GPHybridPageLoadView *)pageLoadView {
    if (!_pageLoadView) {
        _pageLoadView = [[GPHybridPageLoadView alloc]initInSuperView:self withframeY:0 updateCiclerViewY:(self.frame.size.height - SCREEN_HEIGHT)/2];
    }
    return _pageLoadView;
}

//获取h5源码
- (NSString *)h5orignContent {
    if (!_h5orignContent) {
        NSString *documentPath = [[self cachePach] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.html", [NSString GP_hybrid_md5:_request.URL.absoluteString]]];
        _h5orignContent = [NSString stringWithContentsOfFile:documentPath encoding:NSUTF8StringEncoding error:nil];
    }
    return _h5orignContent;
}
//获取h5源码路径
- (NSString *)documentPath {
    if (!_documentPath) {
        _documentPath = [[self cachePach] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.html", [NSString GP_hybrid_md5:_request.URL.absoluteString]]];
    }
    return _documentPath;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        // js配置
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        // WKWebView的配置
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        configuration.allowsInlineMediaPlayback = YES;
        
        _wkWebView = [[WKWebView alloc]initWithFrame:self.bounds configuration:configuration];
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _wkWebView;
}

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityIndicator;
}

//- (NoDataView *)errorView {
//    if (!_errorView) {
//        _errorView = [[NoDataView alloc] initWithFrame:self.wkWebView.frame];
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
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.wkWebView];
        [_bridge setWebViewDelegate:self];
    }
    return _bridge;
}

#pragma mark - WKWebView KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if ([self.delegate respondsToSelector:@selector(wkWebView:didChangeProgress:)]) {
            [self.delegate wkWebView:self didChangeProgress:progress];
        }
    }
    if (object == self.wkWebView && [keyPath isEqualToString:@"title"]) {
        NSString *titleStr = self.wkWebView.title;
        if ([self.delegate respondsToSelector:@selector(wkWebView:getWebViewTitle:)]) {
            [self.delegate wkWebView:self getWebViewTitle:titleStr];
        }
    }
}

//移除observer
- (void)dealloc {
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wkWebView removeObserver:self forKeyPath:@"title"];
    _wkWebView.scrollView.delegate = nil;
}

@end
