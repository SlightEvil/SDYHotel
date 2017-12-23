//
//  SDYPersonalCenterVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYPersonalCenterVC.h"

@interface SDYPersonalCenterVC ()<UITableViewDelegate,UITableViewDataSource>


//@property (nonatomic) UIButton *

@property (nonatomic) UITableView *tableView;


@end

@implementation SDYPersonalCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    
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


#pragma mark - Delegate

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
