//
//  TestView.h
//  testCA
//
//  Created by gangpeng shu on 2017/4/7.
//  Copyright © 2017年 gangpeng shu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum GPCircleViewType {
    EVPCircleViewRefreshType = 1, //下拉刷新
    EVPCircleViewLoadingType,    //转场动画
} GPCircleViewType;

@interface GPHybridPullToRefreshCircleView : UIView

@property (nonatomic, strong) UIImageView *loadingImageView; //圆圈内部的图片
@property (assign, nonatomic) CGFloat contentOffY;           //外界所传偏移量
@property (assign, nonatomic) NSInteger status;              //外界所传状态
@property (nonatomic, assign) GPCircleViewType circleType;

@end
