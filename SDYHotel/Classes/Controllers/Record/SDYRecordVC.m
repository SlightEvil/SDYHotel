//
//  SDYRecordVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYRecordVC.h"
#import "SDYCommodityDetailVC.h"


@interface SDYRecordVC ()

@property (nonatomic, assign) BOOL isAdd;

@property (nonatomic) UIView *addView;

@property (nonatomic) UIButton *blackView;



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

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
