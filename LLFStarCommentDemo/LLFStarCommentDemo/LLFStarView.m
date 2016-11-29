//
//  LLFStarView.m
//  LLFStarCommentDemo
//
//  Created by Apple on 16/11/29.
//  Copyright © 2016年 LLF. All rights reserved.
//

#import "LLFStarView.h"

#define RED_NAME        @"l_star_red"
#define WHITE_NAME      @"l_star_white"

@interface LLFStarView ()

@property (nonatomic, assign) LLFStarType   starType;
@property (nonatomic, assign) CGSize        starSize;

@property (nonatomic, assign) CGFloat       width;
@property (nonatomic, assign) CGFloat       height;
@property (nonatomic, assign) CGFloat       lineMargin;
@property (nonatomic, assign) CGFloat       listMargin;

@property (nonatomic, strong) UIView        *foreView;
@property (nonatomic, strong) UIView        *bgView;

@property (nonatomic, strong) NSMutableArray *starArray;

@end

@implementation LLFStarView

- (instancetype)initWithFrame:(CGRect)frame starSize:(CGSize)starSize starType:(LLFStarType)starType
{
    if (self = [super initWithFrame:frame]) {
        _starType = starType;
        _starSize = starSize;
        self.isTouch = YES; // 默认是可以触摸改变星级
        [self initWithView];
    }
    return self;
}

#pragma mark -- 初始化界面
- (void)initWithView
{
    _starArray = [NSMutableArray array];
    CGFloat width;
    CGFloat height;
    CGFloat lineMargin;
    CGFloat listMargin;
    
    if (_starSize.width == 0 || _starSize.width > self.frame.size.width / 5.0) {
        // 如果除以5.0，会显示星级比较大，所以比例大一点，会使星级比较小点，这个以个人爱好设置
        width = self.frame.size.width / 8.0;
        if (width > self.frame.size.height) {
            width = self.frame.size.height;
        }
        height = width;
        lineMargin = MAX(0, (self.frame.size.height - height) / 2.0);
        listMargin = (self.frame.size.width - 5.0 * width) / 5.0;
    }
    else {
        width = _starSize.width;
        if (width > self.frame.size.height) {
            width = self.frame.size.height;
        }
        height = _starSize.height > self.frame.size.height ? width : _starSize.height;
        lineMargin = MAX((self.frame.size.height - height) / 2.0, 0);
        listMargin = (self.frame.size.width - width * 5.0) / 5.0;
    }
    
    _width = width;
    _height = height;
    _lineMargin = lineMargin;
    _listMargin = listMargin;
    
    if (_starType == LLFStarTypeInteger) {
        for (NSInteger i = 0; i < 5; i++) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i * (_width + _listMargin) + _listMargin / 2.0, _lineMargin, _width, _height)];
            imgView.image = [UIImage imageNamed:RED_NAME];
            [self addSubview:imgView];
            [_starArray addObject:imgView];
        }
    }
    else {
        [self initWithFloatStar];
    }
}

#pragma mark -- 初始化浮点星级
- (void)initWithFloatStar
{
    _foreView = [self createViewWithImageName:RED_NAME flag:YES];
    _bgView   = [self createViewWithImageName:WHITE_NAME flag:NO];
    [self addSubview:_bgView];
    [self addSubview:_foreView];
}


/**
 创建前后层次的（灰色和红色）星级视图

 @param imgName 图片姓名
 @param flag 标志 YES是红色星级视图 NO是灰色星级视图
 @return 红色或灰色星级视图
 */
- (UIView *)createViewWithImageName:(NSString *)imgName flag:(BOOL)flag
{
    UIView *view = [[UIView alloc]initWithFrame:self.bounds];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    view.layer.masksToBounds = YES;
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i * (_width + _listMargin) + _listMargin / 2.0, _lineMargin, _width, _height)];
        imgView.image = [UIImage imageNamed:imgName];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imgView];
        if (flag) {
            [_starArray addObject:imgView];
        }
    }
    return view;
}


/**
 构造set方法

 @param star 最初显示星级的个数
 */
- (void)setStar:(CGFloat)star
{
    star = MAX(0, MIN(5.0, star));
    self.star = _starType == LLFStarTypeInteger ? (int)star : star;
    if (_starType == LLFStarTypeInteger) {
        self.star = self.star == 0 ? 1 : self.star;
        [_starArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imgView = obj;
            if (idx + 1 <= star) {
                imgView.image = [UIImage imageNamed:RED_NAME];
            }
            else {
                imgView.image = [UIImage imageNamed:WHITE_NAME];
            }
        }];
    }
    else {
        int value = star;
        CGFloat width = value * (_width + _lineMargin) + _listMargin / 2.0 + (star - value) * _width;
        _foreView.frame = CGRectMake(0, 0, width, self.frame.size.height);
    }
}
#pragma mark -- 点击改变星级个数
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isTouch) {
        return;
    }
    if (_starType == LLFStarTypeInteger) {
        [self resetIntegerStar:touches];
    }
    else {
        [self resetFloatStar:touches];
    }
}
#pragma mark -- 滑动改变星级个数
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isTouch) {
        return;
    }
    if (_starType == LLFStarTypeInteger) {
        [self resetIntegerStar:touches];
    }
    else {
        [self resetFloatStar:touches];
    }
}
#pragma mark -- 动态显示浮点星级
- (void)resetIntegerStar:(NSSet<UITouch *> *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger star = 0;
    for (NSInteger i = 0; i < 5; i++)
    {
        UIImageView *imgView = _starArray[i];
        if (touchPoint.x >= 0 && touchPoint.x < self.frame.size.width &&
            touchPoint.y >= 0 && touchPoint.y < self.frame.size.height) {
            if (imgView.frame.origin.x > touchPoint.x) {
                imgView.image = [UIImage imageNamed:WHITE_NAME];
            }
            else {
                imgView.image = [UIImage imageNamed:RED_NAME];
                star++;
            }
        }
    }
    if (self.starBlock) {
        self.starBlock([NSString stringWithFormat:@"%ld",star]);
    }
}
#pragma mark -- 动态显示整数星级
- (void)resetFloatStar:(NSSet<UITouch *> *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint starPoint;
    int flag = 0; // 判断是否已经调用block
    CGFloat star = 0;
    if (touchPoint.x >= 0 && touchPoint.x < self.frame.size.width &&
        touchPoint.y >= 0 && touchPoint.y < self.frame.size.height) {
        for (NSInteger i = 0; i < 5; i++) {
            UIImageView *imgView = _starArray[i];
            starPoint = [touch locationInView:imgView];
            if (starPoint.x >= 0 && starPoint.x <= _width) { // 确定点击在星星上了
                CGFloat value = starPoint.x / _width;
                _foreView.frame = CGRectMake(0, 0, imgView.frame.origin.x + _width * value, self.frame.size.height);
                if (flag == 0 && self.starBlock) {
                    self.starBlock([NSString stringWithFormat:@"%.1f", i + value]);
                }
                flag++;
            }
            else {
                _foreView.frame = CGRectMake(0, 0, touchPoint.x, self.frame.size.height);
                if (touchPoint.x > imgView.frame.origin.x) {
                    star = i + 1;
                }
            }
        }
        if (flag == 0 && self.starBlock) {
            // 没有调用block，且当前点击不在星星上
            self.starBlock([NSString stringWithFormat:@"%.1f", star]);
        }
    }
}


@end
