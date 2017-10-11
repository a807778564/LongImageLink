//
//  M80MainInteractor.h
//  M80ImageMerger
//
//  Created by amao on 2016/12/8.
//  Copyright © 2016年 M80. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "M80MergeResult.h"




@protocol M80MainIteractorDelegate <NSObject>
- (void)photosRequestAuthorizationFailed;

- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion;

- (void)showResult:(M80MergeResult *)result;

- (void)mergeBegin;

- (void)mergeEnd;
@end

@interface M80MainInteractor : NSObject
@property (nonatomic,weak)  id<M80MainIteractorDelegate>    delegate;
- (void)run;

- (void)chooseImages;
@end
