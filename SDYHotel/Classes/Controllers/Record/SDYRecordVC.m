//
//  SDYRecordVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYRecordVC.h"



@interface SDYRecordVC ()

@property (nonatomic, assign) BOOL firstCLick;



@end

@implementation SDYRecordVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的收藏";
    


}


- (void)test
{
    /*
     请求一个订单列表
     
     返回一个数组A，该数组为 元素为 一个字典
     {
     shopName : 供应商
     createTime: 创建的时间
     detail: @{  productName:@"小白菜"  }      预定单的商品详情
     post_detail:  @{   }                     配送订单的商品详情
     }
     

     有3个表
     时间表
     预订单表
     配送订单表
     
     要求：
    时间表：  根据返回数组A 中的创建时间createTime 分为今天，昨天
     
     预订单表： 根据选择的时间表的时间 今天/昨天 显示预订单的信息 （section为供应商，
                row 为detail  ）
     配送订单表： 根据选择的时间表的时间 今天/昨天 显示配送订单的信息 （section为供应商
                row为 post_detail )

     */
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
