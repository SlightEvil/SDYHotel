//
//  SDYAddSubtractNumber.m
//  SDYHotel
//
//  Created by admin on 2018/1/2.
//  Copyright © 2018年 SanDaoYi. All rights reserved.
//

#import "SDYAddSubtractNumber.h"
#import "UITextField+Category.h"


@interface SDYAddSubtractNumber ()<UITextFieldDelegate>

/** 减 button */
@property (nonatomic) UIButton *subtractButton;
/** 加 button */
@property (nonatomic) UIButton *addButton;
/** 上限 默认为100 */
@property (nonatomic, assign) NSUInteger ceiling;


@end


@implementation SDYAddSubtractNumber

- (instancetype)init
{
    if (self = [super init]) {
        self.ceiling = 100;
        [self setupInit];
    }
    return self;
}

- (instancetype)initWithCeiling:(NSUInteger)ceiling
{
    if (self = [super init]) {
        
        self.ceiling = ceiling;
        [self setupInit];
    }
    return self;
}

/** 初始化设置 */
- (void)setupInit
{
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:13];
    self.keyboardType = UIKeyboardTypeNumberPad;
    
    self.borderStyle = UITextBorderStyleRoundedRect;
    
    self.leftView = self.subtractButton;
    self.rightView = self.addButton;
    self.delegate = self;
    
    [self setupAccessoryViewWithDone:@"请设置商品的数量"];
    self.text = @"1";
}

#pragma mark - Delegete

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text integerValue] < 1) {
        textField.text = @"1";
    }
    if ([textField.text integerValue] >= 500) {
        textField.text = @"500";
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}


#pragma mark - Event response

- (void)subtractButtonClick:(UIButton *)sender
{
    if ([self.text integerValue] == 1) {
        sender.enabled = NO;
        return;
    } else {
        sender.enabled = YES;
        self.text = [NSString stringWithFormat:@"%zd",[self.text integerValue] -1];
        self.addButton.enabled = YES;
    }
}

- (void)addButtonClick:(UIButton *)sender
{
    if ([self.text integerValue] >= self.ceiling) {
        sender.enabled = NO;
        return;
    } else {
        sender.enabled = YES;
        self.text = [NSString stringWithFormat:@"%zd",[self.text integerValue] +1];
        self.subtractButton.enabled = YES;
    }

}

#pragma mark - Getter and Setter

- (UIButton *)subtractButton
{
    if (!_subtractButton) {
        _subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _subtractButton.layer.borderWidth = 0.5;
        _subtractButton.layer.borderColor = [UIColor grayColor].CGColor;
        _subtractButton.frame = CGRectMake(0, 0, 30, 30);
        [_subtractButton setImage:[UIImage imageNamed:@"icon_subtract"] forState:UIControlStateNormal];
        [_subtractButton addTarget:self action:@selector(subtractButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subtractButton;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.layer.borderColor = [UIColor grayColor].CGColor;
        _addButton.layer.borderWidth = 0.5;
        _addButton.frame = CGRectMake(0, 0, 30, 30);
        [_addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

@end
