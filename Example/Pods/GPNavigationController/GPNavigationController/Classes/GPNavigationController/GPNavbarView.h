//
//  GPNavbarView.h
//  Pods
//
//  Created by gangpeng shu on 2017/5/18.
//
//

#import <UIKit/UIKit.h>

@protocol GPNavbarViewDelegate <NSObject>

@optional

/**
 左侧按钮点击
 */
- (void)p_topLeftBtnClick;

/**
 右侧按钮点击
 */
- (void)p_topRightBtnClick;

@end


@interface GPNavbarView : UIView

@property (nonatomic,strong) UIView *redHotView;              //红点
@property (nonatomic, strong) UILabel *baseTitleLbl;          //导航栏标题
@property (nonatomic, strong) UIButton *baseLeftBtn;          //导航栏左侧按钮
@property (nonatomic, strong) UIButton *baseRightBtn;         //导航栏右侧按钮
@property (nonatomic, strong) NSMutableDictionary *detailDic; //导航栏的设置字典

@property (nonatomic, weak) id<GPNavbarViewDelegate> delegate; //导航栏协议

@end
