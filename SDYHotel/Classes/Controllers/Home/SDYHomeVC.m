//
//  SDYHomeVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYHomeVC.h"
//#import "SDYBaseNavigationVC.h"


@interface SDYHomeVC ()
//立即下单
@property (nonatomic) UIButton *downOrderBtn;
//查看订单
@property (nonatomic) UIButton *lookOrderBtn;
//确认收货
@property (nonatomic) UIButton *confirmCommodityBtn;

@end

@implementation SDYHomeVC


#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"三道易平台";

    
    [self.view addSubview:self.downOrderBtn];
    [self.view addSubview:self.lookOrderBtn];
    [self.view addSubview:self.confirmCommodityBtn];
    
    [self layoutWithAuto];
}

- (void)viewWillAppear:(BOOL)animated
{

}

#pragma mark - Delegate

#pragma mark - Event response

- (void)downOrderBtnClick
{
    [self alertIsDevelopment];
}

- (void)lookOrderBtnClick
{
     [self alertIsDevelopment];
}

- (void)confireCommodityBtnClick
{
     [self alertIsDevelopment];
}

- (void)alertIsDevelopment
{
    [self alertTitle:@"正在开发中" message:nil complete:nil];
}

#pragma mark - Private method

- (void)layoutWithAuto
{
    [self.lookOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    [self.downOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.lookOrderBtn);
        make.right.equalTo(self.lookOrderBtn.mas_left).mas_offset(-20);
    }];
    [self.confirmCommodityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.lookOrderBtn);
        make.left.equalTo(self.lookOrderBtn.mas_right).mas_offset(20);
    }];
}

#pragma mark - Getter and Setter

- (UIButton *)downOrderBtn
{
    if (!_downOrderBtn) {
        _downOrderBtn = [UIButton btnWithTitle:@"立即下单" font:18 textColor:[UIColor blackColor] bgColor:kUIColorFromRGB(0xf0f0f0)];
        [_downOrderBtn addTarget:self action:@selector(downOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downOrderBtn;
}

- (UIButton *)lookOrderBtn
{
    if (!_lookOrderBtn) {
        _lookOrderBtn = [UIButton btnWithTitle:@"查看订单" font:18 textColor:[UIColor blackColor] bgColor:kUIColorFromRGB(0xf0f0f0)];
        [_lookOrderBtn addTarget:self action:@selector(lookOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookOrderBtn;
}

- (UIButton *)confirmCommodityBtn
{
    if (!_confirmCommodityBtn) {
        _confirmCommodityBtn = [UIButton btnWithTitle:@"确认收货" font:18 textColor:[UIColor blackColor] bgColor:kUIColorFromRGB(0xf0f0f0)];
        [_confirmCommodityBtn addTarget:self action:@selector(confireCommodityBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmCommodityBtn;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
