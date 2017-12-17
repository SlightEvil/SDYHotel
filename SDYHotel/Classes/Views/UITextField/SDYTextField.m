//
//  SDYTextField.m
//  SDYHotel
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYTextField.h"

CGFloat leftViewWidth = 45;
CGFloat leftViewHeight = 45;

@implementation SDYTextField

+ (instancetype)textFieldPlaceholder:(NSString *)placeholder font:(CGFloat)font textColor:(UIColor *)textColor
{
    return [[self alloc] initWithPlaceholder:placeholder font:font textColor:textColor];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder font:(CGFloat)font textColor:(UIColor *)textColor
{
    self = [super init];
    self.textColor = textColor ? textColor : [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:font];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.placeholder = placeholder;
    self.borderStyle = UITextBorderStyleRoundedRect;
    
    return self;
}


//leftView像右偏移
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 20;
    return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x += 20;
    rect.size.width -= 20;
    return rect;
    //这里我们只需要移动origin的x 以及缩小width的偏移量
    
    //    CGRectInset(<#CGRect rect#>, <#CGFloat dx#>, <#CGFloat dy#>)
    //先把rect 按照dx dy 平移，再把rect 的大小 按照dx dy 缩小
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x += 20;
    rect.size.width -= 20;
    return rect;
    //这里我们只需要移动origin的x 以及缩小width的偏移量
}


@end
