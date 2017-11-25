//
//  GPBaseNavigationController.h
//  PanBackDemo
//
//  Created by sgp on 5/30/16.
//
//

#import <UIKit/UIKit.h>


@interface GPBaseNavigationController : UINavigationController

@property (readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer; //侧滑手势
@property (nonatomic, assign) BOOL isEnableScroll;                            //是否允许侧滑


/**
 获取上一个控制器

 @return UIViewController
 */
- (UIViewController *)previousViewController;


/**
 获取当前控制器

 @return UIViewController
 */
- (UIViewController *)currentViewController;

@end

@protocol LCPanBackProtocol <NSObject>

/**
 能否侧滑

 @param panNavigationController panNavigationController
 @return BooL
 */
- (BOOL)enablePanBack:(GPBaseNavigationController *)panNavigationController;

/**
 开始侧滑手势

 @param panNavigationController panNavigationController
 */
- (void)startPanBack:(GPBaseNavigationController *)panNavigationController;

/**
 完成侧滑

 @param panNavigationController panNavigationController
 */
- (void)finshPanBack:(GPBaseNavigationController *)panNavigationController;

/**
 重置侧滑手势

 @param panNavigationController panNavigationController
 */
- (void)resetPanBack:(GPBaseNavigationController *)panNavigationController;

@end
