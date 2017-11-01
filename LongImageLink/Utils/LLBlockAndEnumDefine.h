//
//  LLBlockDefine.h
//  LongImageLink
//
//  Created by huangrensheng on 2017/10/14.
//  Copyright © 2017年 laber. All rights reserved.
//

#ifndef LLBlockDefine_h
#define LLBlockDefine_h


/**
 显示图片的顺序枚举
 */
typedef NS_ENUM(NSInteger,LLImagePostion){
    LLImagePostionTop,//最开始的图片
    LLImagePostionMin,//中间的图片
    LLImagePostionBottom//最后一张图片
};

/**
 获取图片和图片裁剪信息
 @param imagesArray 图片
 @param imagePostion 图片裁剪信息
 */
typedef void(^LLImageInfoBlock)(NSMutableArray *imagesArray,NSMutableArray *imagePostion);

/**
 图片视图touch
 @param touchTag 点击的视图
 */
typedef void(^LLImageShowViewTouchBlock)(NSString *touchTag);

#endif /* LLBlockDefine_h */
