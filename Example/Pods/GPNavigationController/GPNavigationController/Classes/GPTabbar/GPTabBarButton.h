//
//  TabBarButton.h
//  GPGaming
//
//  Created by sgp on 15/5/19.
//  Copyright (c) 2015年 weipei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GPTabBarButton : UIButton

/**
 传递进来的Item
 */
@property (nonatomic, strong) UITabBarItem *item;
@property (nonatomic, strong) UIColor *textNormalColor;
@property (nonatomic, strong) UIColor *textSelectColor;

@end
