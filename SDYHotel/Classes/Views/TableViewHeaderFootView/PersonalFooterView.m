//
//  PersonalFooterView.m
//  SDYHotel
//
//  Created by admin on 2017/12/29.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "PersonalFooterView.h"



@interface PersonalFooterView ()

@property (nonatomic) UIButton *registerLoginButton;



@end

@implementation PersonalFooterView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.registerLoginButton.frame = CGRectMake(20, 10, kScreenWidth-40, 40);
        [self.contentView addSubview:self.registerLoginButton];
    }
    return self;
}


- (void)registerLoginButtonClick
{
    if (self.buttonClick) {
        self.buttonClick();
    }
}

- (UIButton *)registerLoginButton
{
    if (!_registerLoginButton) {
        _registerLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerLoginButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_registerLoginButton setTitleColor:kSDYColorGreen forState:UIControlStateNormal];
        _registerLoginButton.backgroundColor = kSDYTitleViewColor;
        [_registerLoginButton addTarget:self action:@selector(registerLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerLoginButton;
}


@end
