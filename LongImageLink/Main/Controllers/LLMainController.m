//
//  LLMainController.m
//  LongImageLink
//
//  Created by huangrensheng on 2017/10/10.
//  Copyright © 2017年 laber. All rights reserved.
//

#import "LLMainController.h"
#import "SVProgressHUD.h"
#import "M80ImageViewController.h"
#import "UIView+Toast.h"
#import "M80MainInteractor.h"
#import "M80ImageGenerator.h"

@interface LLMainController ()<M80MainIteractorDelegate>
@property (strong, nonatomic) UIButton *okButton;
@property (strong,nonatomic) M80MainInteractor *iteractor;
@end

@implementation LLMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _okButton = [[UIButton alloc] init];
    [_okButton addTarget:self action:@selector(onMergeBegin:) forControlEvents:UIControlEventTouchUpInside];
    [_okButton setTitle:@"合并" forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.view addSubview:_okButton];
    [_okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.offset(150);
        make.height.offset(70);
    }];
    
    _okButton.layer.cornerRadius = 5.0;
    _okButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _okButton.layer.borderWidth = 1;
    _okButton.layer.masksToBounds = YES;
    
    _iteractor = [[M80MainInteractor alloc] init];
    _iteractor.delegate = self;
    [_iteractor run];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)onMergeBegin:(id)sender {
    [_iteractor chooseImages];
}

#pragma mark - M80MainIteractorDelegate
- (void)photosRequestAuthorizationFailed
{
    [self.view makeToast:@"请开启相册权限"];
}

- (void)showResult:(M80MergeResult *)result
{
    NSError *error = result.error;
    if (error)
    {
        NSInteger code = [error code];
        switch (code) {
            case M80MergeErrorNotSameWidth:
                [self showNotSameWidthTip];
                break;
            case M80MergeErrorNotEnoughOverlap:
                [self showNotEnoughOverlapError];
                break;
            default:
                assert(0);
                break;
        }
    }
    else
    {
        [self showImageResult:result];
    }
}

- (void)mergeBegin
{
    [SVProgressHUD show];
}

- (void)mergeEnd
{
    [SVProgressHUD dismiss];
}


#pragma mark - misc
- (void)showNotSameWidthTip
{
    [self.view makeToast:@"请选择相同宽度的图片"];
}

- (void)showNotEnoughOverlapError
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"拼接失败"
                                                                        message:@"请选择有足够重叠内容的图片进行拼接"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [controller addAction:action];
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

- (void)showImageResult:(M80MergeResult *)result
{
    dispatch_block_t block = ^{
        
        M80ImageViewController *vc = [[M80ImageViewController alloc] initWithImage:result.image];
        vc.completion = result.completion;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav
                           animated:YES
                         completion:nil];
    };
    
    
    if (self.presentedViewController != nil)
    {
        [self dismissViewControllerAnimated:YES
                                 completion:block];
    }
    else
    {
        block();
    }
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
