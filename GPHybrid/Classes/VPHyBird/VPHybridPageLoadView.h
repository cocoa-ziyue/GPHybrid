//
//  VPPageLoadView.h
//  Pods
//
//  Created by gangpeng shu on 2017/4/10.
//
//

#import <UIKit/UIKit.h>
#import "VPHybridPullToRefreshCircleView.h"
//提示状态机
typedef enum VPPageLoadViewStatus {
    VPPageLoadViewStatusActive = 1, //无提示
    VPPageLoadViewStatusEnd = 0,
} VPPageLoadViewStatus;


@interface VPHybridPageLoadView : UIView

@property (nonatomic, strong) UIImageView *loadingAniImgV;           //过渡动画ImageView
@property (nonatomic, strong) UILabel *loadingLbl;                   //过渡加载动画提示
@property (nonatomic, strong) VPHybridPullToRefreshCircleView *circleView; //过渡动画转圈
@property (nonatomic, assign) VPPageLoadViewStatus loadStatus;       //过渡动画状态

/**
 便捷初始化

 @param superView 父视图
 @param frameY 在父视图的y坐标
 @param ciclerViewY 调整转圈的y坐标
 */
- (instancetype)initInSuperView:(UIView *)superView withframeY:(CGFloat)frameY updateCiclerViewY:(CGFloat)ciclerViewY;


@end
