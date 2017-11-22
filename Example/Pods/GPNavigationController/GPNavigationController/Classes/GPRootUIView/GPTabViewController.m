//
//  GPTabViewController.m
//  FBSnapshotTestCase
//
//  Created by sgp on 2017/11/12.
//

#import "GPTabViewController.h"

@interface GPTabViewController ()

@end

@implementation GPTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化tabbar
    [self setupTabbar];
    // 移除系统tabbar的顶部黑线
    [self p_removeTopBlackLine];
}

//移除系统的tabbar
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            view.frame = CGRectMake(view.frame.origin.x, self.view.bounds.size.height-TabbarHeight, view.frame.size.width, TabbarHeight);
        }
    }
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

//加入自定义的tabber
- (void)setupTabbar {
    GPTabBar *customTabBar = [[GPTabBar alloc] init];
    customTabBar.frame = CGRectMake(0, 0, self.tabBar.frame.size.width, TabbarHeight);
    //customTabBar.delegate = self;
    customTabBar.backgroundColor = [UIColor clearColor];
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

// 移除系统tabbar的顶部黑线
- (void)p_removeTopBlackLine {
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
