//
//  GPPanGestureRecognizer.h
//  PanBackDemo
//
//  Created by clovelu on 5/30/16.
//
//

#import <UIKit/UIKit.h>


@interface GPPanGestureRecognizer : UIPanGestureRecognizer

@property (readonly, nonatomic) UIEvent *event; //屏幕的手势事件

- (CGPoint)beganLocationInView:(UIView *)view; //在屏幕的点位

@end
