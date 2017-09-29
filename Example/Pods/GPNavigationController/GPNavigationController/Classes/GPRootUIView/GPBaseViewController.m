//
//  GPBaseViewController.m
//  GPGaming
//
//  Created by shugangpeng on 16/12/23.
//  Copyright © 2016年 weipei. All rights reserved.
//

#import "GPBaseViewController.h"
#import "Reachability.h"
#import "GPNavtionBarDefines.h"

@interface GPBaseViewController () <GPNavbarViewDelegate>

@end


@implementation GPBaseViewController

#pragma mark -
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //网络监测
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [reach startNotifier];
}

- (void)viewWillDisAppear:(BOOL)animated {
    [self viewWillDisAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - network listening

- (void)reachabilityChanged:(NSNotification *)notification {
    Reachability *reach = [notification object];
    if (![reach isReachable]) {
//        [UIView showBlackToastViewTilte:@"当前网络异常，请稍后重试！" duration:0.8];
    }
}

- (void)setNetWorkIsAvailable:(BOOL)netWorkIsAvailable {
    _netWorkIsAvailable = netWorkIsAvailable;
    if (!netWorkIsAvailable) {
//        [UIView showBlackToastViewTilte:@"当前网络异常，请稍后重试！"];
    }
}

#pragma mark -
#pragma mark - public method  complements

- (void)showNetWorkingMsg:(NSString *)content isSuccess:(BOOL)Flag {
//    [UIView showBlackToastViewTilte:content duration:0.8];
}

- (void)p_setTopTitleDetail:(NSMutableDictionary *)params {
    if (!params) {
        return;
    }
    self.topTitleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NavHeight);
    [self.view insertSubview:self.topTitleView atIndex:0];
    _topTitleView.detailDic = params;
}

- (void)p_openPanBackThisVcInApp:(BOOL)flag {
    GPBaseNavigationController *navVc = (GPBaseNavigationController *)self.navigationController;
    navVc.isEnableScroll = flag;
}


#pragma mark -
#pragma mark - GPNavbarViewDelegate
- (void)p_topLeftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)p_topRightBtnClick {
}

#pragma mark -
#pragma mark Accesstor methods

- (GPNavbarView *)topTitleView {
    if (!_topTitleView) {
        _topTitleView = [[GPNavbarView alloc] init];
        _topTitleView.delegate = self;
    }
    return _topTitleView;
}

@end
