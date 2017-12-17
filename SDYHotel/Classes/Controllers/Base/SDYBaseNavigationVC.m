//
//  SDYBaseNavigationVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYBaseNavigationVC.h"

@interface SDYBaseNavigationVC ()

@end

@implementation SDYBaseNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
//    self.navigationBar.hidden = YES;
//    self.navigationBar.tintColor = kUIColorFromRGB(0x06ce8a);
    self.navigationBar.barTintColor = kUIColorFromRGB(0x06ce8a);
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
