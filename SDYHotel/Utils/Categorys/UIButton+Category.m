//
//  UIButton+Category.m
//  SDYHotel
//
//  Created by admin on 2017/12/11.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)


+ (instancetype)btnWithTitle:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor ? textColor : [UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font ? font : 18];
    [btn setBackgroundColor:bgColor];
    return btn;
}

@end
