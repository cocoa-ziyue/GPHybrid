//
//  TabBar.m
//  GPGaming
//
//  Created by yzx on 15/5/19.
//  Copyright (c) 2015年 weipei. All rights reserved.
//

#import "GPTabBar.h"
#import "GPTabBarButton.h"

@interface GPTabBar ()

/**
 *  记录当前选中的按钮
 */
@property (nonatomic, weak) GPTabBarButton *selectedButton;

/**
 * 判断模糊组件是否已经Insert
 */
@property (nonatomic, assign) BOOL isInsert;

@end


@implementation GPTabBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tabColor ? (self.backgroundColor = self.tabColor):(self.backgroundColor = [UIColor whiteColor]);
    }
    return self;
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item {
    // 1.创建按钮
    GPTabBarButton *button = [[GPTabBarButton alloc] init];
    button.textSelectColor = self.textSelectedColor;
    button.textNormalColor = self.textNormalColor;
    [self addSubview:button];

    // 2.设置数据
    button.item = item;

    // 3.监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
}

- (void)addTabButtonWithName:(NSString *)name selName:(NSString *)selName {
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(GPTabBarButton *)button {
    // 1.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:(short)self.selectedButton.tag to:(short)button.tag];
    }
    if ([self.delegate respondsToSelector:@selector(tabBar:currentBtn:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self currentBtn:button didSelectedButtonFrom:(short)self.selectedButton.tag to:(short)button.tag];
    }
    // 2.设置按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.isInsert) {
        return;
    }

    // 按钮的frame数据
    CGFloat buttonH = 49;
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonY = 0;

    for (int index = 0; index < self.subviews.count; index++) {
        // 1.取出按钮
        GPTabBarButton *button = self.subviews[index];

        // 2.设置按钮的frame
        CGFloat buttonX = index * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);

        // 3.绑定tag
        button.backgroundColor = [UIColor clearColor];
        button.tag = index;
    }

    // 添加模糊效果
    UIToolbar *toobar = [[UIToolbar alloc] init];
    toobar.barStyle = UIBarStyleDefault;
    toobar.translucent = YES;
    toobar.frame = self.bounds;
    [self insertSubview:toobar atIndex:0];
    self.isInsert = YES;
}

- (void)selectIndex:(NSInteger)index {
    BOOL hideGuessModule = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hideGuessModule"] boolValue];
    if (hideGuessModule && index >= 4) {
        index = index - 1;
    }
    GPTabBarButton *button = self.subviews[index];
    // 2.设置按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

@end
