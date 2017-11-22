//
//  GPTabViewController.h
//  FBSnapshotTestCase
//
//  Created by sgp on 2017/11/12.
//

#import <UIKit/UIKit.h>
#import "GPTabBar.h"

@interface GPTabViewController : UITabBarController

@property (nonatomic, strong) GPTabBar *customTabBar;       //自定义的tabbar

@end
