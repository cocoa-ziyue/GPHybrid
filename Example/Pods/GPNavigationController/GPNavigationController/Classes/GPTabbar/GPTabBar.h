//
//  TabBar.h
//  GPGaming
//
//  Created by yzx on 15/5/19.
//  Copyright (c) 2015年 weipei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPTabBar;
@class GPTabBarButton;

@protocol TabBarDelegate <NSObject>

@optional

/**
 @param tabBar GPTabBar
 @param from 上一个选择的按钮的Tag值
 @param to 将要选择的按钮的Tag值
 */
- (void)tabBar:(GPTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;

/**
 @param tabBar GPTabBar
 @param from 上一个选择的按钮的Tag值
 @param to 将要选择的按钮的Tag值
 */
- (void)tabBar:(GPTabBar *)tabBar currentBtn:(GPTabBarButton *)button didSelectedButtonFrom:(int)from to:(int)to;

@end


@interface GPTabBar : UIView

@property (nonatomic, strong) UIColor *tabColor;
@property (nonatomic, strong) UIColor *textNormalColor;
@property (nonatomic, strong) UIColor *textSelectedColor;

@property (nonatomic, weak) id<TabBarDelegate> delegate;

/**
 添加一个系统样式的UITabBarItem

 @param item UITabBarItem实例
 */
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

/**
 *  用来添加一个内部的按钮
 *
 *  @param name    按钮未选中时的图片名称
 *  @param selName 按钮选中时的图片名称
 */
- (void)addTabButtonWithName:(NSString *)name selName:(NSString *)selName;

/**
 选择一个默认的index
 
 @param index 当前选择的index
 */
- (void)selectIndex:(NSInteger)index;

@end
