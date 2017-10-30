//
//  LLMergeToolController.m
//  LongImageLink
//
//  Created by huangrensheng on 2017/10/17.
//  Copyright © 2017年 laber. All rights reserved.
//

#import "LLMergeToolController.h"
#import "M80ImageMergeInfo.h"
#import "LLImageShowView.h"
#import "LLImageShowView.h"

@interface LLMergeToolController ()
@property (nonatomic, strong) UIScrollView *contentView;
@end

@implementation LLMergeToolController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(doLeftAction:)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.contentView = [[UIScrollView alloc] init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    for (int i = 0; i < self.images.count; i++) {
        LLImageShowView *upView = nil;
        M80ImageMergeInfo *merInfo = nil;
        M80ImageMergeInfo *upMerInfo = nil;
        UIImage *upImage = nil;
        if (i>0) {
            merInfo = self.postions[i-1];
            upView = self.contentView.subviews[i-1];
            upImage = self.images[i-1];
            if (i>1) {
                upMerInfo = self.postions[i-1];
            }
        }
        UIImage *image = self.images[i];
        LLImageShowView *imageView = [[LLImageShowView alloc] initWithImage:image tag:i];
        imageView.imageScroll.scrollEnabled = NO;
        imageView.insetTop = merInfo?(image.size.height-merInfo.secondOffset)/imageScale:0;
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.equalTo(self.contentView);
            make.width.offset(image.size.width/imageScale);
            make.height.offset(merInfo.secondOffset/imageScale);
            if (i==0) {
                make.top.equalTo(self.contentView.mas_top);
            }else{
                make.top.equalTo(upView.mas_bottom);
            }
            if (i == self.images.count-1) {
                make.bottom.equalTo(self.contentView.mas_bottom);
            }
        }];
        
        [upView mas_updateConstraints:^(MASConstraintMaker *make) {//更新中间视图的高度
            if (i>1) {
                make.height.offset((upImage.size.height-upMerInfo.firstOffset-(upImage.size.height-upMerInfo.secondOffset))/imageScale);
            }else{
                make.height.offset((upImage.size.height-merInfo.firstOffset)/imageScale);
            }
        }];
    }
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doLeftAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
