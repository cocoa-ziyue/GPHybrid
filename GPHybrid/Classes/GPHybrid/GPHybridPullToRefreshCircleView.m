//
//  TestView.m
//  testCA
//
//  Created by gangpeng shu on 2017/4/7.
//  Copyright © 2017年 gangpeng shu. All rights reserved.
//

#import "GPHybridPullToRefreshCircleView.h"

#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degress) ((pi * degress) / 180)

@interface GPHybridPullToRefreshCircleView ()

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end


@implementation GPHybridPullToRefreshCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setStatus:(NSInteger)status {
    _status = status;
    if (status == 3) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        [self.layer removeAnimationForKey:@"GProtation"];
        self.isLoading = NO;
    }
}

- (void)setContentOffY:(CGFloat)contentOffY {
    _contentOffY = contentOffY;
    //通知自定义的view重新绘制图形
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_contentOffY > -50 && _contentOffY <= -10) {
        //1.获取图形上下文
        CGContextRef ctxBlack = UIGraphicsGetCurrentContext();
        //2.绘图
        //在自定义的view中画一个圆
        CGContextAddArc(ctxBlack, rect.size.width / 2, rect.size.height + _contentOffY / 2, _contentOffY / 2.5 + 10/2.5, 0, 2 * M_PI, 1);
        //设置圆的填充颜色
        [HWColor(60, 60, 60) set];
        //3.渲染
        CGContextFillPath(ctxBlack);
        if (_contentOffY < -30) {
            //1.获取图形上下文
            CGContextRef ctxWhite = UIGraphicsGetCurrentContext();
            //2.绘图
            //在自定义的view中画一个圆
            CGContextAddArc(ctxWhite, rect.size.width / 2, rect.size.height + _contentOffY / 2, (_contentOffY + 30) / 1.5, 0, 2 * M_PI, 1);
            //设置圆的填充颜色
            [[UIColor whiteColor] set];
            //3.渲染
            CGContextFillPath(ctxWhite);
        }
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        [self.layer removeAnimationForKey:@"GProtation"];
        self.isLoading = NO;
    } else if (_contentOffY <= -50) {
        //1.获取图形上下文
        CGContextRef ctxBlack1 = UIGraphicsGetCurrentContext();
        //2.绘图
        //在自定义的view中画一个圆
        CGContextAddArc(ctxBlack1, rect.size.width / 2, rect.size.height / 2, 40 / 2.5, 0, 2 * M_PI, 1);
        //设置圆的填充颜色
        [HWColor(60, 60, 60) set];
        //3.渲染
        CGContextFillPath(ctxBlack1);
        
        //1.获取图形上下文
        CGContextRef ctxWhite1 = UIGraphicsGetCurrentContext();
        //2.绘图
        //在自定义的view中画一个圆
        CGContextAddArc(ctxWhite1, rect.size.width / 2, rect.size.height / 2, 40 / 2.5 - 2, 0, 2 * M_PI, 1);
        //设置圆的填充颜色
        [[UIColor whiteColor] set];
        //3.渲染
        CGContextFillPath(ctxWhite1);
        
        if (!self.isLoading) {
            UIBezierPath *thePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:40 / 2.5 - 1 startAngle:0 endAngle:DEGREES_TO_RADIANS(45) clockwise:YES];
            self.shapeLayer.path = thePath.CGPath;
            [self.layer addSublayer:self.shapeLayer];
            CABasicAnimation *animation = [CABasicAnimation animation];
            animation.keyPath = @"transform.rotation.z";
            animation.duration = 1.f;
            animation.fromValue = @(0);
            animation.toValue = @(2 * M_PI);
            animation.repeatCount = INFINITY;
            animation.removedOnCompletion = NO;
            [self.layer addAnimation:animation forKey:@"GProtation"];
            self.isLoading = YES;
        }
    }
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = HWColor(220, 220, 220).CGColor;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineWidth = 2.5;
    }
    return _shapeLayer;
}

- (void)startImgLoading {
    //    NSArray *imagesArray = [NSArray arrayWithObjects:
    //                            [UIImage imageNamed:@"headerload_0"],[UIImage imageNamed:@"headerload_1"],
    //                            [UIImage imageNamed:@"headerload_2"],[UIImage imageNamed:@"headerload_3"],
    //                            [UIImage imageNamed:@"headerload_4"],[UIImage imageNamed:@"headerload_5"],
    //                            [UIImage imageNamed:@"headerload_6"],[UIImage imageNamed:@"headerload_7"],
    //                            [UIImage imageNamed:@"headerload_8"],[UIImage imageNamed:@"headerload_9"],
    //                            [UIImage imageNamed:@"headerload_10"],[UIImage imageNamed:@"headerload_11"],
    //                            [UIImage imageNamed:@"headerload_12"],[UIImage imageNamed:@"headerload_13"],
    //                            [UIImage imageNamed:@"headerload_14"],[UIImage imageNamed:@"headerload_15"],
    //                            [UIImage imageNamed:@"headerload_16"],[UIImage imageNamed:@"headerload_17"],
    //                            [UIImage imageNamed:@"headerload_18"],[UIImage imageNamed:@"headerload_19"],
    //                            [UIImage imageNamed:@"headerload_20"],
    //                            nil];
    //    self.loadingImageView.animationImages = imagesArray;//将序列帧数组赋给UIImageView的animationImages属性
    //    self.loadingImageView.animationDuration = 2;//设置动画时间
    //    self.loadingImageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    //    [self.loadingImageView startAnimating]; //开始播放动画
}

- (void)stopImgLoading {
    if (_loadingImageView) {
        [_loadingImageView stopAnimating];
        [_loadingImageView removeFromSuperview];
        _loadingImageView = nil;
    }
}

- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] init];
    }
    return _loadingImageView;
}

@end
