//
//  LLImageShowView.m
//  LongImageLink
//
//  Created by huangrensheng on 2017/10/30.
//  Copyright © 2017年 laber. All rights reserved.
//

#import "LLImageShowView.h"

@interface LLImageShowView()
@property (nonatomic, strong) UIButton *imageView;
@property (nonatomic, assign) float offTop;//上距离
@property (nonatomic, assign) float offBottom;//下距离
@property (nonatomic, assign) float offHeight;
@property (nonatomic, strong) UIImage *ofImage;
@property (nonatomic, strong) NSString *touchOther;
@end

@implementation LLImageShowView

- (instancetype)initWithImage:(UIImage *)image{
    if ([super init]) {
        
        self.ofImage = image;
        
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
        
        self.imageView = [[UIButton alloc] init];
        [self.imageView addTarget:self action:@selector(addTouchObject:) forControlEvents:UIControlEventTouchDown];
        [self.imageView addTarget:self action:@selector(removeTouchObject:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageView addTarget:self action:@selector(moveTouchObject:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        
        [self.imageView setImage:image forState:UIControlStateNormal];
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

- (void)remakeImageConstraints{
    [self.imageScroll mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageScroll);
    }];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.leading.equalTo(self.contentView.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing);
        make.width.offset(self.ofImage.size.width/[UIScreen mainScreen].scale);
        make.height.offset(self.ofImage.size.height/[UIScreen mainScreen].scale);
    }];
    [self layoutIfNeeded];
}

- (void)setTopOffset:(float)topOffset{
    _topOffset = topOffset;
    self.offTop = _topOffset;
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(-topOffset);
    }];
}

- (void)setTouchs:(NSMutableArray *)touchs{
    for (NSString *tou in touchs) {
//        NSLog(@"tou = %@",tou);
        if ([tou integerValue] != self.tag) {
            self.touchOther = tou;
//            NSLog(@"touchOther = %@",tou);
            break;
        }
    }
}

- (void)addTouchObject:(UIButton *)btn{
    self.offHeight = self.frame.size.height;
    self.offBottom = self.imageHeight-self.frame.size.height-self.offTop;
    if (self.touchBlock) {
        self.touchBlock([NSString stringWithFormat:@"%.ld",self.tag]);
    }
}

- (void)removeTouchObject:(UIButton *)btn{
    if (self.touchBlock) {
        self.touchBlock([NSString stringWithFormat:@"%.ld",self.tag]);
    }
    self.touchOther = @"";
}

- (void)moveTouchObject:(UIButton *)btn withEvent:(UIEvent *)myEvent{
    //得到某个触摸对象，如果支持多点触摸，可得到多个对象
    UITouch *touch = [myEvent allTouches].anyObject;
    //得到触摸对象当前点
    CGPoint locationPoint = [touch locationInView:self.superview];
    //得到移动之前所在的点
    CGPoint prePoint = [touch previousLocationInView:self.superview];
    //计算delX delY，就是x,y所移动的距离
    NSLog(@"self.tag = %ld otherTag = %@",self.tag,self.touchOther);
//    float delX = locationPoint.x - prePoint.x;
    float delY = locationPoint.y - prePoint.y;
    if (delY>0) {
        if (self.imagePos == LLImagePostionTop) {
            self.offHeight -= 1;
        }else if(self.imagePos == LLImagePostionBottom){
            self.offTop -= 1;
            self.offHeight += 1;
        }else{
//            if (self.tag>[self.touchOther integerValue]&&[self.touchOther integerValue]!=0) {
//                self.offTop += 1;
//                self.offHeight -= 1;
//            }else{
                self.offTop -= 1;
                self.offHeight += 1;
//            }
        }
    }else{
        if (self.imagePos == LLImagePostionTop) {
            self.offHeight += 1;
        }else if(self.imagePos == LLImagePostionBottom){
            self.offTop += 1;
            self.offHeight -= 1;
        }else{
            if (self.tag>[self.touchOther integerValue]&&[self.touchOther integerValue]!=0) {
                self.offTop += 1;
                self.offHeight -= 1;
            }else if (self.tag<[self.touchOther integerValue]&&[self.touchOther integerValue]!=0) {
                self.offBottom += 1;
                self.offHeight -= 1;
            }else{
                self.offBottom -= 1;
                self.offHeight += 1;
            }
        }
    }
    if (self.offTop < 0) {
        self.offTop = 0;
    }
    if (self.offBottom < 0) {
        self.offBottom = 0;
    }
    if (self.offHeight > self.imageHeight) {
        self.offHeight = self.imageHeight;
    }
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(-self.offTop);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(self.offBottom);
    }];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(self.offHeight);
    }];
    NSLog(@"tag=%ld delY=%.2f ",self.tag,delY);
}

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesMoved:touches withEvent:event];
//    //得到某个触摸对象，如果支持多点触摸，可得到多个对象
//    UITouch *touch = touches.anyObject;
//    //得到触摸对象当前点
//    CGPoint locationPoint = [touch locationInView:self.superview];
//    //得到移动之前所在的点
//    CGPoint prePoint = [touch previousLocationInView:self.superview];
//    //计算delX delY，就是x,y所移动的距离
//
//    float delX = locationPoint.x - prePoint.x;
//    float delY = locationPoint.y - prePoint.y;
//    if (delY>0) {
//        self.offY += 1;
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.offset(self.offY);
//        }];
//    }else{
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            self.offY -= 1;
//            [self mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.offset(self.offY);
//            }];
//        }];
//    }
//    NSLog(@"tag=%ld delX=%.2f delY=%.2f locationPoint=%@ prePoint=%@",self.tag,delX,delY,NSStringFromCGPoint(locationPoint),NSStringFromCGPoint(prePoint));
//}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesEnded:touches withEvent:event];
//    if (self.touchBlock) {
//        self.touchBlock([NSString stringWithFormat:@"%.ld",self.tag]);
//    }
//}

@end
