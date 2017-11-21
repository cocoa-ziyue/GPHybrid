//
//  GPPageLoadView.h
//  Pods
//
//  Created by gangpeng shu on 2017/4/10.
//
//

#import <UIKit/UIKit.h>
#import "GPHybridPullToRefreshCircleView.h"
//提示状态机
typedef enum GPPageLoadViewStatus {
    GPPageLoadViewStatusActive = 1, //无提示
    GPPageLoadViewStatusEnd = 0,
} GPPageLoadViewStatus;


@interface GPHybridPageLoadView : UIView

@property (nonatomic, strong) UIImageView *loadingAniImgV;           //过渡动画ImageView
@property (nonatomic, strong) UILabel *loadingLbl;                   //过渡加载动画提示
@property (nonatomic, strong) GPHybridPullToRefreshCircleView *circleView; //过渡动画转圈
@property (nonatomic, assign) GPPageLoadViewStatus loadStatus;       //过渡动画状态

/**
 便捷初始化

 @param superView 父视图
 @param frameY 在父视图的y坐标
 @param ciclerViewY 调整转圈的y坐标
 */
- (instancetype)initInSuperView:(UIView *)superView withframeY:(CGFloat)frameY updateCiclerViewY:(CGFloat)ciclerViewY;


@end
