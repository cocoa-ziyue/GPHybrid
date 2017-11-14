# GPHybrid

[![CI Status](http://img.shields.io/travis/ziyue92/GPHybrid.svg?style=flat)](https://travis-ci.org/ziyue92/GPHybrid)
[![Version](https://img.shields.io/cocoapods/v/GPHybrid.svg?style=flat)](http://cocoapods.org/pods/GPHybrid)
[![License](https://img.shields.io/cocoapods/l/GPHybrid.svg?style=flat)](http://cocoapods.org/pods/GPHybrid)
[![Platform](https://img.shields.io/cocoapods/p/GPHybrid.svg?style=flat)](http://cocoapods.org/pods/GPHybrid)

## 一、安装：
pod安装：pod 'GPHybrid'

## 二、相关介绍：
### 1.模块构成

### 2.使用介绍

## 三、使用入门：
### 1.继承Vc，见上图
### 2.继承view（wkwebview、webviewview），见代码里注释
### 3.JS和OC交互  
#### 3.1 OC --- > JS  
 [self.bridge registerHandler:@"clickOnTips" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *info = (NSDictionary *)data;
    }];

#### 3.2  JS  --- >  OC 
[self.wkWebView.wkWebView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError *_Nullable error) {
                CGFloat webHeight = [result floatValue];
                self.commentTableView.emheaderHeight = webHeight;          
}];

#### 更多功能请查看注释。

#### iOS技术交流群：674228487
#### [欢迎关注我的博客](http://blog.csdn.net/u010670946)  

## 四、其他：
### Requirements
iOS 8+

### Author
ziyue92, ziyue92@qq.com

### License
GPHybrid is available under the MIT license. See the LICENSE file for more info.
