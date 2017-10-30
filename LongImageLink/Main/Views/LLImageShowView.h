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
- (instancetype)initWithImage:(UIImage *)image tag:(NSInteger)tag;

@property (nonatomic, assign) float insetTop;// 上边距信息
@property (nonatomic, copy) LLImageShowViewTouchBlock touchBlock;
@property (nonatomic, strong) UIScrollView *imageScroll;
@property (nonatomic, strong) UIView *contentView;
@end
