# GPHybrid

[![CI Status](http://img.shields.io/travis/ziyue92/GPHybrid.svg?style=flat)](https://travis-ci.org/ziyue92/GPHybrid)
[![Version](https://img.shields.io/cocoapods/v/GPHybrid.svg?style=flat)](http://cocoapods.org/pods/GPHybrid)
[![License](https://img.shields.io/cocoapods/l/GPHybrid.svg?style=flat)](http://cocoapods.org/pods/GPHybrid)
[![Platform](https://img.shields.io/cocoapods/p/GPHybrid.svg?style=flat)](http://cocoapods.org/pods/GPHybrid)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
## Introduction

### 前言
```text
Hybrid框架主要以JS+Native两者相互调用为主，从开发层面实现“一次开发，多处运行”的机制，成为真正适合跨平台的开发。  
目前已经有众多Hybrid App开发成功应用，比如百度、网易等知名移动应用，都是采用Hybrid App开发模式。  
因此GPHybird实现了JS+Native无缝调用、常见网页处理功能、常见客户端处理功能。实现UIWebview和WKWebView跟据操作系统自动适应。  
在iOS8+的设备上,使用WKWebView并封装了常见的功能接口，使用起来简单稳定。
```

### 架构思维导图
![GPHybrid模块组成介绍](https://github.com/ziyue92/folder/raw/master/GPHybird模块介绍.png)

### 使用介绍思维导图
![GPHybrid使用介绍](https://github.com/ziyue92/folder/raw/master/GPHybrid使用指南.png)

### 常见功能详解
#### 1.使用vc加载h5网页，只需继承GPWebViewController，调用如下方法，一句代码就完成了网页加载。
```objective-c
//1.1 简单url(NSString)
[self loadWebViewWithUrlStr:@"https://www.baidu.com"];
//1.2 简单request(NSMutableURLRequest)
NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
[self loadWebViewWithUrlRequest:request];
//1.3 简单request(NSMutableURLRequest带header，或body)
NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
[request addValue:@"en_us" forHTTPHeaderField:@"lang"];
[self loadWebViewWithUrlRequest:request];
```
#### 2.异步获取标题
```objective-c
@weakify(self);
self.getWebVTitle = ^(NSString *title) {
     @strongify(self);
     [self p_setTopTitleDetail:@{Nav_Title:title}.mutableCopy];
};
```
#### 3.异步实时获取当前请求的url
```objective-c
@weakify(self);
self.getWebVUrl = ^(NSString *url) {
     @strongify(self);
     do sth...
};
```
#### 4.刷新
```objective-c
[self refresh];
```
#### 5.返回上一级（自动判断是退出vc，还是回退网页）
```objective-c
[self goBack];
```
#### 6.设置cookie
```objective-c
//设置cookies
NSString *doMainstring = @".baidu.com";
self.cookies = @{@"Token":@"xxxxxxx",@"Lang":@"en_us",@"Domain":doMainstring,@"source":@"ios"};
[self.uiWebView addCookieswithDict:self.cookies.mutableCopy];
```
#### 7.JS与OC交互
```objective-c
//7.1 JS调用OC，OC注册JS事件，OC响应数据。
[self.bridge registerHandler:@"findAllmgs" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data isKindOfClass:[NSArray class]]) {
            @strongify(self);
            self.imgArr = (NSArray *)data;
        }
}];
//7.2 OC调用JS，OC执行JS事件，JS响应数据。
[self.wkWebView.wkWebView evaluateJavaScript:javascript completionHandler:^(id _Nullable result, NSError * _Nullable error) {
       CGFloat webHeight = [result floatValue];
       self.commentTableView.emheaderHeight = webHeight;
       [self updatewebViewHeight:webHeight];
}];   
```
#### 8.只使用UIWebview
```objective-c
//注意此属性需要在[super viewDidLoad]之前设置
self.isforceUseoldWebView = YES;
[super viewDidLoad];
```

## Mark

iOS开发交流群：674228487
欢迎关注我的博客：[Coder大鹏](http://blog.csdn.net/u010670946) 

## Requirements

iOS7+

## Installation

GPHybrid is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GPHybrid'
```

## Author

ziyue92, ziyue92@qq.com

## License

GPHybrid is available under the MIT license. See the LICENSE file for more info.

