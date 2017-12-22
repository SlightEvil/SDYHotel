//
//  SDYPersonalCenterVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYPersonalCenterVC.h"

@interface SDYPersonalCenterVC ()

@end

@implementation SDYPersonalCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (APPCT.isLogin) {
        self.navigationItem.title = APPCT.loginUser.user_name;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!APPCT.isLogin) {
        [APPCT showLoginViewCon];
    } 
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
