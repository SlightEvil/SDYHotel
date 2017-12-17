//
//  SDYMoneyCenterVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYMoneyCenterVC.h"

@interface SDYMoneyCenterVC ()

@end

@implementation SDYMoneyCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"财务中心";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self alertTitle:@"正在开发中" message:nil complete:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
