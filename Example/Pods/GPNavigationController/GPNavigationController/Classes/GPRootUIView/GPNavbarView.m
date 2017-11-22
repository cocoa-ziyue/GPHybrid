//
//  GPNavbarView.m
//  Pods
//
//  Created by gangpeng shu on 2017/5/18.
//
//

#import "GPNavbarView.h"
#import "GPNavtionBarDefines.h"


@implementation GPNavbarView
#pragma mark -
#pragma mark Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self setBuler];
    }
    return self;
}


#pragma mark -
#pragma mark private methods

- (void)rightBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(p_topRightBtnClick)]) {
        [self.delegate p_topRightBtnClick];
    }
}

- (void)leftBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(p_topLeftBtnClick)]) {
        [self.delegate p_topLeftBtnClick];
    }
}

- (void)setBuler {
    // 添加模糊效果
    UIToolbar *toobar = [[UIToolbar alloc] init];
    toobar.barStyle = UIBarStyleDefault;
    toobar.translucent = YES;
    toobar.frame = self.bounds;
}

- (void)setDetailDic:(NSMutableDictionary *)detailDic {
    _detailDic = detailDic;

    CGSize size;
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    CGFloat offset = 5;

    if ([detailDic valueForKey:Nav_Title]) {
        self.baseTitleLbl.backgroundColor = [UIColor clearColor];
        [self addSubview:_baseTitleLbl];
        _baseTitleLbl.text = [NSString stringWithFormat:@"%@", [detailDic valueForKey:Nav_Title]];
    }

    if ([detailDic valueForKey:Nav_Left]) {
        self.baseLeftBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_baseLeftBtn];
        UIImage *img = [UIImage imageNamed:[detailDic valueForKey:Nav_Left]];
        [_baseLeftBtn setImage:img forState:UIControlStateNormal];
        size = img.size;
        size.width = size.width > 44 ? size.width : 44;
        _baseLeftBtn.frame = CGRectMake(offset, StatusHeight, size.width, 44);
    }

    if ([detailDic valueForKey:Nav_LeftTxt]) {
        self.baseLeftBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_baseLeftBtn];
        [_baseLeftBtn setTitle:[detailDic valueForKey:Nav_LeftTxt] forState:UIControlStateNormal];
        [_baseLeftBtn setTitleColor:GPColor(205, 218, 220) forState:UIControlStateNormal];
        _baseLeftBtn.titleLabel.font = font;
        size = LBL_TEXTSIZE([detailDic valueForKey:Nav_LeftTxt], font);
        _baseLeftBtn.frame = CGRectMake(offset * 2, StatusHeight, size.width, 44);
    }

    if ([detailDic valueForKey:Nav_RightImg]) {
        self.baseRightBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_baseRightBtn];
        UIImage *img = [UIImage imageNamed:[detailDic valueForKey:Nav_RightImg]];
        [_baseRightBtn setImage:img forState:UIControlStateNormal];
        size = img.size;
        size.width = size.width > 44 ? size.width : 44;
        _baseRightBtn.frame = CGRectMake(SCREEN_WIDTH - offset - size.width, StatusHeight, size.width, 44);
    }

    if ([detailDic valueForKey:Nav_Right]) {
        self.baseRightBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_baseRightBtn];
        [_baseRightBtn setTitle:[detailDic valueForKey:Nav_Right] forState:UIControlStateNormal];
        [_baseRightBtn setTitleColor:GPColor(205, 218, 220) forState:UIControlStateNormal];
        _baseRightBtn.titleLabel.font = font;
        size = LBL_TEXTSIZE([detailDic valueForKey:Nav_Right], font);
        _baseRightBtn.frame = CGRectMake(SCREEN_WIDTH - 2 * offset - size.width, StatusHeight, size.width, 44);
    }

    CGFloat maxX = _baseRightBtn.frame.size.width > 0 ? MAX(_baseLeftBtn.frame.size.width, _baseRightBtn.frame.size.width) : _baseLeftBtn.frame.size.width;
    _baseTitleLbl.frame = CGRectMake(maxX + offset, StatusHeight, SCREEN_WIDTH - 2 * (maxX + offset), 44);
}

#pragma mark -
#pragma mark Accesstor methods

- (UILabel *)baseTitleLbl {
    if (!_baseTitleLbl) {
        _baseTitleLbl = [[UILabel alloc] init];
        _baseTitleLbl.textAlignment = NSTextAlignmentCenter;
        _baseTitleLbl.font = [UIFont systemFontOfSize:18.0];
        _baseTitleLbl.textColor = [UIColor whiteColor];
    }
    return _baseTitleLbl;
}

- (UIButton *)baseRightBtn {
    if (!_baseRightBtn) {
        _baseRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_baseRightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _baseRightBtn;
}

- (UIButton *)baseLeftBtn {
    if (!_baseLeftBtn) {
        _baseLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_baseLeftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _baseLeftBtn;
}

@end
