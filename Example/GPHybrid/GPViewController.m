//
//  GPViewController.m
//  GPHybrid
//
//  Created by ziyue92 on 11/22/2017.
//  Copyright (c) 2017 ziyue92. All rights reserved.
//

#import "GPViewController.h"
#import "GPDemoWebViewController.h"

@interface GPViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *alerView;

@end

@implementation GPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"欢迎使用GPHybird";
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"使用简单url(NSString)方式" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"使用简单url(NSURLRequest)方式" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setTitle:@"使用复杂url(NSMutableURLRequest)方式" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setTitle:@"设置网页的cookie" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn5 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 setTitle:@"使用转圈提示加载" forState:UIControlStateNormal];
    [btn5 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn6 addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn6 setTitle:@"使用进度条加载" forState:UIControlStateNormal];
    [btn6 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    btn1.tag = 1000;
    btn2.tag = 1001;
    btn3.tag = 1002;
    btn4.tag = 1003;
    btn5.tag = 1004;
    btn6.tag = 1005;
    
    [btn1 sizeToFit];
    [btn2 sizeToFit];
    [btn3 sizeToFit];
    [btn4 sizeToFit];
    [btn5 sizeToFit];
    [btn6 sizeToFit];
    
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    [self.view addSubview:btn5];
    [self.view addSubview:btn6];
    
    btn1.center = CGPointMake(self.view.center.x,self.view.center.y - 200);
    btn2.center = CGPointMake(self.view.center.x,self.view.center.y - 150);
    btn3.center = CGPointMake(self.view.center.x,self.view.center.y - 100);
    btn4.center = CGPointMake(self.view.center.x,self.view.center.y - 50);
    btn5.center = CGPointMake(self.view.center.x,self.view.center.y);
    btn6.center = CGPointMake(self.view.center.x,self.view.center.y + 50);
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"⚠️⚠️⚠️使用本框架默认开启了本框架自定义的转圈，若不想用转圈来提示用户，则可以用进度条来提示用户。\n更多功能请参照.h文件的注释";
    [label sizeToFit];
    label.frame = CGRectMake(20, self.view.center.y + 100, self.view.frame.size.width-40, 100);
    [self.view addSubview:label];
}

- (void)btnPressed:(UIButton *)sender {
    self.alerView.tag = sender.tag;
    if (sender.tag == 1000) {
        self.alerView.message = @"继承GPWebViewController，调用[self loadWebViewWithUrlStr]";
    } else if (sender.tag == 1001) {
        self.alerView.message = @"继承GPWebViewController，自定义NSMutableURLRequest,调用[self loadWebViewWithUrlRequest]";
    } else if (sender.tag == 1002) {
        self.alerView.message = @"继承GPWebViewController，自定义NSMutableURLRequest,可加入header或body,调用[self loadWebViewWithUrlRequest]";
    } else if (sender.tag == 1003) {
        self.alerView.message = @"设置cookie，目前只支持UIWebview，需要在viewDidload[super viewDidLoad]之前设置self.isforceUseoldWebView = YES再使用设置cookie的办法: NSString *doMainstring = @'.baidu.com';\nself.cookies = @{@'Token':@'xxxxxxx',@'Lang':@'en_us',@'Domain':doMainstring,@'source':@'ios'};\n[self.uiWebView addCookieswithDict:self.cookies.mutableCopy];";
    } else if (sender.tag == 1004) {
        self.alerView.message = @"默认使用转圈，要使用进度条则self.showProgressView = YES";
    } else if (sender.tag == 1005) {
        self.alerView.message = @"默认使用转圈，要使用进度条则self.showProgressView = YES";
    }
    
    [self.alerView show];
}


#pragma mark
#pragma mark----- UIAlertViewDelegate -----

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    GPDemoWebViewController *demoWeb = [GPDemoWebViewController new];
    
    if (alertView.tag == 1000) {
        //一句话搞定加载
        [demoWeb loadWebViewWithUrlStr:@"https://www.baidu.com"];
    } else if (alertView.tag == 1001) {
        //加载简单urlrequest
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
        [demoWeb loadWebViewWithUrlRequest:request.mutableCopy];
    } else if (alertView.tag == 1002) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
        [request setValue:@"en_us" forHTTPHeaderField:@"lang"];
        [demoWeb loadWebViewWithUrlRequest:request];
    } else if (alertView.tag == 1003) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
        [request setValue:@"en_us" forHTTPHeaderField:@"lang"];
        [demoWeb loadWebViewWithUrlRequest:request];
    } else if (alertView.tag == 1004) {
        [demoWeb loadWebViewWithUrlStr:@"https://www.baidu.com"];
    } else if (alertView.tag == 1005) {
        demoWeb.showProgressView = YES;
        [demoWeb loadWebViewWithUrlStr:@"https://www.baidu.com"];
    }
    [self.navigationController pushViewController:demoWeb animated:YES];
}

- (UIAlertView *)alerView {
    if (!_alerView) {
        _alerView = [[UIAlertView alloc] initWithTitle:@"使用方法" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"点击前往", nil];
        _alerView.delegate = self;
    }
    return _alerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

