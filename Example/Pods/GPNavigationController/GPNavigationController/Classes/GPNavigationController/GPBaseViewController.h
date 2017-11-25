//
//  GPBaseViewController.h
//  GPGaming
//
//  Created by shugangpeng on 16/12/23.
//  Copyright © 2016年 weipei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPBaseNavigationController.h"
#import "GPNavbarView.h"
#import "GPNavtionBarDefines.h"

@interface GPBaseViewController : UIViewController

@property (nonatomic, assign) BOOL netWorkIsAvailable; //当前网络是否可连接

/*******自定义导航栏(适用于动画效果,各种模糊效果等)******/
@property (nonatomic, strong) GPNavbarView *topTitleView;

/**
 *  自定义导航栏头部
 */
- (void)p_setTopTitleDetail:(NSMutableDictionary *)params;

/**
 *  响应自定义头部左侧点击
 */
- (void)p_topLeftBtnClick;

/**
 *  响应自定义头部右侧点击
 */
- (void)p_topRightBtnClick;


/**
 加载网络显示提示信息

 @param content 显示提示信息内容
 @param Flag 成功或失败
 */
- (void)showNetWorkingMsg:(NSString *)content isSuccess:(BOOL)Flag;

/**
 * 自定义push转场动画
 */
//-(void)p_pushToVc:(UIViewController *)viewController animated:(BOOL)flag;

/**
 * 关闭某个页面侧滑(注意关闭某个页面侧滑，请在该类viewwilldissapear中开启)
 */
- (void)p_openPanBackThisVcInApp:(BOOL)flag;

@end
