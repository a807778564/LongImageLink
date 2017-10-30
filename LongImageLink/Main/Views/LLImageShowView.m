//
//  LLImageShowView.m
//  LongImageLink
//
//  Created by huangrensheng on 2017/10/30.
//  Copyright © 2017年 laber. All rights reserved.
//

#import "LLImageShowView.h"

@interface LLImageShowView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) float offY;
@end

@implementation LLImageShowView

- (instancetype)initWithImage:(UIImage *)image tag:(NSInteger)tag{
    if ([super init]) {
        self.tag = tag;
        self.imageScroll = [[UIScrollView alloc] init];
        [self addSubview:self.imageScroll];
        [self.imageScroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.contentView = [[UIView alloc] init];
        [self.imageScroll addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imageScroll);
        }];
        
        self.imageView = [[UIImageView alloc] initWithImage:image];
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.leading.equalTo(self.contentView.mas_leading);
            make.trailing.equalTo(self.contentView.mas_trailing);
            make.width.offset(image.size.width/[UIScreen mainScreen].scale);
            make.height.offset(image.size.height/[UIScreen mainScreen].scale);
        }];
    }
    return self;
}

- (void)setInsetTop:(float)insetTop{
    _insetTop = insetTop;
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageScroll.mas_top).offset(-insetTop);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.offY = self.frame.size.height;
    if (self.touchBlock) {
        self.touchBlock([NSString stringWithFormat:@"%.ld",self.tag]);
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    //得到某个触摸对象，如果支持多点触摸，可得到多个对象
    UITouch *touch = touches.anyObject;
    //得到触摸对象当前点
    CGPoint locationPoint = [touch locationInView:self.superview];
    //得到移动之前所在的点
    CGPoint prePoint = [touch previousLocationInView:self.superview];
    //计算delX delY，就是x,y所移动的距离
    
    float delX = locationPoint.x - prePoint.x;
    float delY = locationPoint.y - prePoint.y;
    if (delY>0) {
        self.offY += 1;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self.offY);
        }];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.offY -= 1;
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(self.offY);
            }];
        }];
    }
    NSLog(@"tag=%ld delX=%.2f delY=%.2f locationPoint=%@ prePoint=%@",self.tag,delX,delY,NSStringFromCGPoint(locationPoint),NSStringFromCGPoint(prePoint));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (self.touchBlock) {
        self.touchBlock([NSString stringWithFormat:@"%.ld",self.tag]);
    }
}

@end
