//
//  GPBaseNavigationController.m
//  PanBackDemo
//
//  Created by sgp on 5/30/16.
//
//

#import "GPBaseNavigationController.h"
#import "GPBaseViewController.h"
#import "GPNavbarView.h"
#import "GPPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "UIView+Snapshot.h"

static const NSString *contentImageKey = @"contentImageKey";
static const NSString *barImageKey = @"barImageKey";
static const NSString *contentFrameKey = @"contentFrameKey";


@interface GPBaseNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) GPPanGestureRecognizer *pan;
@property (strong, nonatomic) NSMutableArray *shotStack;
@property (strong, nonatomic) UIImageView *previousMirrorView;
@property (strong, nonatomic) UIImageView *previousBarMirrorView;
@property (strong, nonatomic) UIView *previousOverLayView;
@property (assign, nonatomic) BOOL animatedFlag;

@property (readonly, nonatomic) UIView *controllerWrapperView;
@property (weak, nonatomic) UIView *barBackgroundView;
@property (weak, nonatomic) UIView *barBackIndicatorView;

@property (assign, nonatomic) CGFloat showViewOffsetScale;
@property (assign, nonatomic) CGFloat showViewOffset;
@end


@implementation GPBaseNavigationController

#pragma mark -
#pragma mark lifeCycle methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isEnableScroll = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.enabled = NO; //禁用系统侧滑
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarHidden:YES];
    self.delegate = self;
    _pan = [[GPPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    _pan.delegate = self;
    _pan.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:_pan];
    self.isEnableScroll = YES; //默认开启侧滑

    _shotStack = [NSMutableArray array];
    _previousMirrorView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _previousMirrorView.backgroundColor = [UIColor clearColor];

    _previousOverLayView = [[UIView alloc] initWithFrame:_previousMirrorView.bounds];
    _previousOverLayView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _previousOverLayView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    [_previousMirrorView addSubview:_previousOverLayView];


    _previousBarMirrorView = [[UIImageView alloc] initWithFrame:self.navigationBar.bounds];
    _previousBarMirrorView.backgroundColor = [UIColor clearColor];

    self.showViewOffsetScale = 1 / 3.0;
    self.showViewOffset = self.showViewOffsetScale * self.view.frame.size.width;
}

#pragma mark -
#pragma mark private methods

- (void)setViewControllers:(NSArray *)viewControllers {
    [super setViewControllers:viewControllers];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *previousViewController = [self.viewControllers lastObject];

    if (previousViewController) {

        NSMutableDictionary *shotInfo = [NSMutableDictionary dictionary];
        UIImage *barImage = [self barSnapshot];
        UIImage *contentImage = [WINDOW snapshot];

        double delayInSeconds = animated ? 0.35 : 0.1; // 等按钮状态恢复到normal状态
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            shotInfo[contentImageKey] = contentImage;
            shotInfo[barImageKey] = barImage;
            shotInfo[contentFrameKey] = [NSValue valueWithCGRect:previousViewController.view.frame];
            [self.shotStack addObject:shotInfo];

        });

        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 动画标识，在动画的情况下，禁掉右滑手势
    [self startAnimated:animated];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self.shotStack removeLastObject];

    [self startAnimated:animated];

    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // TODO: shotStack handle
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    [self.shotStack removeAllObjects];
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark -
#pragma mark Pan

- (void)pan:(UIPanGestureRecognizer *)pan {
    UIGestureRecognizerState state = pan.state;
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            NSDictionary *shotInfo = [self.shotStack lastObject];
            UIImage *contentImage = shotInfo[contentImageKey];
            UIImage *barImage = shotInfo[barImageKey];
            CGRect rect = [shotInfo[contentFrameKey] CGRectValue];

            self.previousMirrorView.image = contentImage;
            self.previousMirrorView.frame = rect;
            self.previousMirrorView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -self.showViewOffset, 0);
            [self.controllerWrapperView insertSubview:self.previousMirrorView belowSubview:self.visibleViewController.view];

            self.previousOverLayView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];

            self.previousBarMirrorView.image = barImage;
            self.previousBarMirrorView.frame = self.navigationBar.bounds;
            self.previousBarMirrorView.alpha = 0;
            [self.navigationBar addSubview:self.previousBarMirrorView];
            [self startPanBack];

            break;
        }

        case UIGestureRecognizerStateChanged: {
            CGPoint translationPoint = [self.pan translationInView:self.view];

            if (translationPoint.x < 0) translationPoint.x = 0;
            if (translationPoint.x > SCREEN_WIDTH) translationPoint.x = SCREEN_WIDTH;

            CGFloat k = translationPoint.x / SCREEN_WIDTH;

            [self barTransitionWithAlpha:1 - k];
            self.previousBarMirrorView.alpha = k;

            self.previousMirrorView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -self.showViewOffset + translationPoint.x * self.showViewOffsetScale, 0);

            self.previousOverLayView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2 * (1 - k)];
            self.visibleViewController.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, translationPoint.x, 0);

            break;
        }

        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {

            CGPoint velocity = [self.pan velocityInView:self.view];
            BOOL reset = velocity.x < 0;

            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [UIView animateWithDuration:0.3 animations:^{

                CGFloat alpha = reset ? 1.f : 0.f;
                [self barTransitionWithAlpha:alpha];
                self.previousBarMirrorView.alpha = 1 - alpha;
                self.previousMirrorView.transform = reset ? CGAffineTransformTranslate(CGAffineTransformIdentity, -self.showViewOffset, 0) : CGAffineTransformIdentity;
                self.visibleViewController.view.transform = reset ? CGAffineTransformIdentity : CGAffineTransformTranslate(CGAffineTransformIdentity, SCREEN_WIDTH, 0);
                self.previousOverLayView.backgroundColor = reset ? [[UIColor grayColor] colorWithAlphaComponent:0.2] : [UIColor clearColor];

            } completion:^(BOOL finished) {

                [[UIApplication sharedApplication] endIgnoringInteractionEvents];

                [self barTransitionWithAlpha:1];

                self.visibleViewController.view.transform = CGAffineTransformIdentity;
                self.previousMirrorView.transform = CGAffineTransformIdentity;
                self.previousMirrorView.image = nil;

                self.previousBarMirrorView.image = nil;
                self.previousBarMirrorView.alpha = 0;

                [self.previousMirrorView removeFromSuperview];
                [self.previousBarMirrorView removeFromSuperview];

                self.barBackgroundView = nil;

                [self finshPanBackWithReset:reset];

                if (!reset) {
                    [self popViewControllerAnimated:NO];
                }
            }];
            break;
        }

        default:
            break;
    }
}

#pragma mark GestureRecognizer Delegate

#define MIN_TAN_VALUE tan(M_PI / 6)

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count < 2) return NO;
    if (self.animatedFlag) return NO;
    if (![self enablePanBack]) return NO; // 询问当前viewconroller 是否允许右滑返回

    CGPoint touchPoint = [gestureRecognizer locationInView:self.controllerWrapperView];
    if (touchPoint.x < 0 || touchPoint.y < 10 || touchPoint.x > 220) return NO;

    CGPoint translation = [gestureRecognizer translationInView:self.view];
    if (translation.x <= 0) return NO;

    // 是否是右滑
    BOOL succeed = fabs(translation.y / translation.x) < MIN_TAN_VALUE;
    if (!self.isEnableScroll) { //个别页面不允许侧滑
        succeed = NO;
    }

    return succeed;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer != self.pan) return NO;
    if (self.pan.state != UIGestureRecognizerStateBegan) return NO;

    if (otherGestureRecognizer.state != UIGestureRecognizerStateBegan) {

        return YES;
    }

    CGPoint touchPoint = [self.pan beganLocationInView:self.controllerWrapperView];

    // 点击区域判断 如果在左边 30 以内, 强制手势后退
    if (touchPoint.x < 30) {

        [self cancelOtherGestureRecognizer:otherGestureRecognizer];
        return YES;
    }

    // 如果是scrollview 判断scrollview contentOffset 是否为0，是 cancel scrollview 的手势，否cancel自己
    if ([[otherGestureRecognizer view] isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)[otherGestureRecognizer view];
        if (scrollView.contentOffset.x <= 0) {

            [self cancelOtherGestureRecognizer:otherGestureRecognizer];
            return YES;
        }
    }

    return NO;
}

- (void)cancelOtherGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSSet *touchs = [self.pan.event touchesForGestureRecognizer:otherGestureRecognizer];
    [otherGestureRecognizer touchesCancelled:touchs withEvent:self.pan.event];
}


#pragma mark -
#pragma mark Custom

- (void)startAnimated:(BOOL)animated {
    self.animatedFlag = YES;

    NSTimeInterval delay = animated ? 0.8 : 0.1;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishedAnimated) object:nil];
    [self performSelector:@selector(finishedAnimated) withObject:nil afterDelay:delay];
}

- (void)finishedAnimated {
    self.animatedFlag = NO;
}

- (void)barTransitionWithAlpha:(CGFloat)alpha {
    //透明度渐变效果
    if ([self.currentViewController isKindOfClass:[GPBaseViewController class]]) {
        GPBaseViewController *cunrrentVc = (GPBaseViewController *)self.currentViewController;
        GPNavbarView *navBar = cunrrentVc.topTitleView;
        if (navBar.baseLeftBtn) {
            navBar.baseLeftBtn.alpha = alpha;
        }

        if (navBar.baseTitleLbl) {
            navBar.baseTitleLbl.alpha = alpha;
        }

        if (navBar.baseRightBtn) {
            navBar.baseRightBtn.alpha = alpha;
        }
    }
}

#pragma mark -
#pragma mark Accesstor methods

- (UIPanGestureRecognizer *)panGestureRecognizer {
    return self.pan;
}

- (UIView *)controllerWrapperView {
    return self.visibleViewController.view.superview;
}

- (UIView *)barBackgroundView {
    if (_barBackgroundView) return _barBackgroundView;

    for (UIView *subview in self.navigationBar.subviews) {
        if (!subview.hidden && subview.frame.size.height >= self.navigationBar.frame.size.height && subview.frame.size.width >= self.navigationBar.frame.size.width) {
            _barBackgroundView = subview;
            break;
        }
    }
    return _barBackgroundView;
}

- (UIView *)barBackIndicatorView {
    if (!_barBackIndicatorView) {
        for (UIView *subview in self.navigationBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
                _barBackIndicatorView = subview;
                break;
            }
        }
    }
    return _barBackIndicatorView;
}

- (UIImage *)barSnapshot {
    self.barBackgroundView.hidden = YES;
    UIImage *viewImage = [self.navigationBar snapshot];
    self.barBackgroundView.hidden = NO;
    return viewImage;
}

#pragma mark LCPanBackProtocol

- (BOOL)enablePanBack {
    BOOL enable = YES;
    if ([self.visibleViewController respondsToSelector:@selector(enablePanBack:)]) {
        UIViewController<LCPanBackProtocol> *viewController = (UIViewController<LCPanBackProtocol> *)self.visibleViewController;
        enable = [viewController enablePanBack:self];
    }
    if ([self.visibleViewController isKindOfClass:[UITabBarController class]]) {
        enable = NO;
    }
    return enable;
}

- (void)startPanBack {
    if ([self.visibleViewController respondsToSelector:@selector(startPanBack:)]) {
        UIViewController<LCPanBackProtocol> *viewController = (UIViewController<LCPanBackProtocol> *)self.visibleViewController;
        [viewController startPanBack:self];
    }
}

- (void)finshPanBackWithReset:(BOOL)reset {
    if (reset) {
        [self resetPanBack];
    } else {
        [self finshPanBack];
    }
}

- (void)finshPanBack {
    if ([self.visibleViewController respondsToSelector:@selector(finshPanBack:)]) {
        UIViewController<LCPanBackProtocol> *viewController = (UIViewController<LCPanBackProtocol> *)self.visibleViewController;
        [viewController finshPanBack:self];
    }
}

- (void)resetPanBack {
    if ([self.visibleViewController respondsToSelector:@selector(resetPanBack:)]) {
        UIViewController<LCPanBackProtocol> *viewController = (UIViewController<LCPanBackProtocol> *)self.visibleViewController;
        [viewController resetPanBack:self];
    }
}


#pragma mark - ChildViewController

- (UIViewController *)currentViewController {
    UIViewController *result = nil;
    if ([self.viewControllers count] > 0) {
        result = [self.viewControllers lastObject];
    }
    return result;
}

#pragma mark - ParentViewController

- (UIViewController *)previousViewController {
    UIViewController *result = nil;
    if ([self.viewControllers count] > 1) {
        result = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    }
    return result;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!self.isNeedBluer) {
        return;
    }
    // 删除系统自带的tabBarButton
    for (UIView *tabBar in self.tabBarController.tabBar.subviews) {
        if ([tabBar isKindOfClass:[UIControl class]]) {
            [tabBar removeFromSuperview];
        }
    }
}

@end
