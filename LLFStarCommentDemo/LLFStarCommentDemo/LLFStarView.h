//
//  LLFStarView.h
//  LLFStarCommentDemo
//
//  Created by Apple on 16/11/29.
//  Copyright © 2016年 LLF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LLFStarType) { // 星级类型
    // 整数
    LLFStarTypeInteger = 0,
    // 浮点，允许半个左右的星级
    LLFStarTypeFloat,
};

@interface LLFStarView : UIView

// 最初显示星级的个数（默认显示0星级）
@property (nonatomic, assign) CGFloat star;
// 是否允许触摸改变显示的星星 默认YES
@property (nonatomic, assign) BOOL isTouch;
// 回调
@property (nonatomic, copy) void(^starBlock)(NSString *value);


/**
 构造方法

 @param frame view的frame
 @param starSize 星级的大小
 @param starType 星级的类型，整数显示还是浮点显示
 @return 星级的视图
 */
- (instancetype)initWithFrame:(CGRect)frame
                     starSize:(CGSize)starSize
                     starType:(LLFStarType)starType;


@end
