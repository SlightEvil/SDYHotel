//
//  SDYTextField.h
//  SDYHotel
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat leftViewWidth;
FOUNDATION_EXPORT CGFloat leftViewHeight;


@interface SDYTextField : UITextField

+ (instancetype)textFieldPlaceholder:(NSString *)placeholder font:(CGFloat)font textColor:(UIColor *)textColor;

- (instancetype)initWithPlaceholder:(NSString *)placeholder font:(CGFloat)font textColor:(UIColor *)textColor;


@end
