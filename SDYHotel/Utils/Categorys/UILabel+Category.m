//
//  UILabel+Category.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

+ (instancetype)labelWithTextColor:(UIColor *)textColor font:(CGFloat)font
{
    UILabel *label = [[self alloc] init];
    label.textColor = textColor ? textColor : [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:font];
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.2;
    return label;
}

@end
