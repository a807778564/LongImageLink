//
//  LLImageShowView.h
//  LongImageLink
//
//  Created by huangrensheng on 2017/10/30.
//  Copyright © 2017年 laber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLImageShowView : UIView

/**
 初始化图片显示 和位置
 @param image 图片
 @return 返回对象
 */
- (instancetype)initWithImage:(UIImage *)image;

@property (nonatomic, assign) LLImagePostion imagePos;//图片位置
@property (nonatomic, assign) float topOffset;// 上边距信息
@property (nonatomic, assign) float bottonOffset;// 上边距信息
@property (nonatomic, assign) float imageHeight;
@property (nonatomic, strong) NSMutableArray *touchs;

@property (nonatomic, copy) LLImageShowViewTouchBlock touchBlock;
@property (nonatomic, strong) UIScrollView *imageScroll;
@property (nonatomic, strong) UIView *contentView;

- (void)remakeImageConstraints;
@end
