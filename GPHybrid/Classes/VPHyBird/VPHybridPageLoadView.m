//
//  VPPageLoadView.m
//  Pods
//
//  Created by gangpeng shu on 2017/4/10.
//
//

#import "VPHybridPageLoadView.h"
#import "UIView+HybridMJExtension.h"

@interface VPHybridPageLoadView ()

@end

@implementation VPHybridPageLoadView

- (instancetype)initInSuperView:(UIView *)superView withframeY:(CGFloat)frameY updateCiclerViewY:(CGFloat)ciclerViewY{
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor whiteColor];
        [superView addSubview:self];
        self.frame = CGRectMake(superView.mj_x, frameY, superView.mj_w, superView.mj_h);
        if ([superView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *temp = (UIScrollView *)superView;
            self.mj_x = temp.contentOffset.x;
        }
        [self layoutViews];
        [self updateCircleView:ciclerViewY];
    }
    return self;
}

- (void)layoutViews{
    [self addSubview:self.circleView];
    [self addSubview:self.loadingLbl];
    [self.loadingLbl sizeToFit];
    self.circleView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
    CGFloat tmpy = 0;
    if (self.mj_y == 60) {
        tmpy = [UIScreen mainScreen].bounds.size.height - 60;
    } else {
        tmpy = [UIScreen mainScreen].bounds.size.height - self.mj_y;
    }
    self.circleView.center = CGPointMake(self.center.x, tmpy/2 - self.loadingLbl.mj_h/2);
    self.loadingLbl.center = CGPointMake(self.circleView.center.x, CGRectGetMaxY(self.circleView.frame)+ self.loadingLbl.mj_h/2);
}

- (void)updateCircleView:(CGFloat)circleViewY {
    self.circleView.mj_y += circleViewY;
    self.loadingLbl.center = CGPointMake(self.circleView.center.x, CGRectGetMaxY(self.circleView.frame)+ self.loadingLbl.mj_h/2);
    [self startLoading];
}

#pragma mark - 控制转圈状态

- (void)setLoadStatus:(VPPageLoadViewStatus)loadStatus {
    _loadStatus = loadStatus;
    switch (loadStatus) {
        case VPPageLoadViewStatusActive:
        {
            [self startLoading];
        }
            break;
        case VPPageLoadViewStatusEnd:
        {
            [self endLoading];
        }
            break;
        default:
            break;
    }
}

- (void)startLoading {
    _loadStatus = VPPageLoadViewStatusActive;
    self.circleView.contentOffY = -50;
    self.superview.userInteractionEnabled = NO;
}

- (void)endLoading {
    _loadStatus = VPPageLoadViewStatusEnd;
    self.superview.userInteractionEnabled = YES;
    self.circleView.status = 3;
    if (self.circleView) {
        [self.circleView removeFromSuperview];
        self.circleView = nil;
    }
    if (self.loadingAniImgV) {
        [self.loadingAniImgV stopAnimating];
        [self.loadingAniImgV removeFromSuperview];
        self.loadingAniImgV = nil;
    }
    if (self.loadingLbl) {
        [self.loadingLbl removeFromSuperview];
        self.loadingLbl = nil;
    }
    [self removeFromSuperview];
}

- (UIImageView *)loadingAniImgV {
    if (!_loadingAniImgV) {
        _loadingAniImgV = [[UIImageView alloc] init];
    }
    return _loadingAniImgV;
}

- (UILabel *)loadingLbl {
    if (!_loadingLbl) {
        _loadingLbl = [[UILabel alloc] init];
        _loadingLbl.font = [UIFont fontWithName:@"Helvetica" size:11];
        _loadingLbl.textColor = TextBgColor;
        _loadingLbl.textAlignment = NSTextAlignmentCenter;
        _loadingLbl.text = @"玩命加载中...";
    }
    return _loadingLbl;
}

- (VPHybridPullToRefreshCircleView *)circleView {
    if (!_circleView) {
        _circleView = [[VPHybridPullToRefreshCircleView alloc] init];
        _circleView.circleType = EVPCircleViewLoadingType;
        _circleView.backgroundColor = [UIColor clearColor];
    }
    return _circleView;
}

@end
