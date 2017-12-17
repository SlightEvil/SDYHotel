//
//  SDYRecordVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYRecordVC.h"
#import "SDYCommodityDetailVC.h"
#import "ProductDetailView.h"

@interface SDYRecordVC ()

@property (nonatomic, assign) BOOL isAdd;

@property (nonatomic) UIView *addView;

@property (nonatomic) UIButton *blackView;

@property (nonatomic) ProductDetailView *detailView;


@end

@implementation SDYRecordVC
{
    SDYCommodityDetailVC *vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的收藏";
     vc = [SDYCommodityDetailVC new];
     vc.view.frame = CGRectMake(0, 200, kScreenWidth, kScreenHeight - 200);
    
    
    
    CGRect frame = self.addView.frame;
    frame.origin.y = kScreenHeight;
    self.addView.frame = frame;

    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self alertTitle:@"正在开发中" message:nil complete:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
 
    [self.detailView showView];
    
    
    
    
//    [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.addView];
//    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        CGRect frame = self.addView.frame;
//        frame.origin.y = 200;
//        self.addView.frame = frame;
//        self.blackView.alpha = 1;
//    } completion:^(BOOL finished) {
//        _isAdd = !_isAdd;
//    }];
  
}

- (void)blackViewBtnClick
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = self.addView.frame;
        frame.origin.y = kScreenHeight;
        self.addView.frame = frame;
        
        self.blackView.alpha = 0.2;
        
    } completion:^(BOOL finished) {
        
        [self.addView removeFromSuperview];
//        self.blackView.alpha = 1;
        [self.blackView removeFromSuperview];
    }];
}

















- (void)addChildViewCon {
    
    if (self.isAdd) {
        
        [vc willMoveToParentViewController:self];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    } else {
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc didMoveToParentViewController:self];
    }
    
    NSLog(@"aaaaaa");
    self.isAdd = !self.isAdd;
}



- (UIView *)addView
{
    if (!_addView) {
        _addView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, kScreenHeight - 100)];
        _addView.backgroundColor = [UIColor whiteColor];
    }
    return _addView;
}

- (UIButton *)blackView
{
    if (!_blackView) {
        _blackView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_blackView addTarget:self action:@selector(blackViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.blackView.alpha = 0.2;
    }
    return _blackView;
}

- (ProductDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[ProductDetailView alloc] init];
    }
    return _detailView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
