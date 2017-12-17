//
//  ProductDetailView.m
//  SDYHotel
//
//  Created by admin on 2017/12/15.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ProductDetailView.h"
#import "UIButton+Category.h"
#import "UILabel+Category.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProductDetailModel.h"

@interface ProductDetailView ()

@property (nonatomic) UIImageView *iconImage;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *unitLabel;
@property (nonatomic) UILabel *unitTextLable;

@property (nonatomic) UILabel *numberLabel;
@property (nonatomic) UIButton *addNumberBtn;
@property (nonatomic) UIButton *reduceNumberBtn;
@property (nonatomic) UITextField *numberTextField;

@property (nonatomic) UIView *whiteBgView;
@property (nonatomic) UIButton *comppleteBtn;

@property (nonatomic) ProductDetailProductModel *productModel;

//@property (nonatomic)


@end

@implementation ProductDetailView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kUIColorFromRGB(0xf0f0f0);
        [self addSubview:self.iconImage];
        [self addSubview:self.comppleteBtn];
        [self addSubview:self.nameLabel];
        [self addSubview:self.unitLabel];
        [self addSubview:self.unitTextLable];
        [self addSubview:self.numberLabel];
        [self addSubview:self.reduceNumberBtn];
        [self addSubview:self.numberTextField];
        [self addSubview:self.addNumberBtn];

        [self layoutWithAuto];
    }
    return self;
}

#pragma mark - event response

- (void)reduceNumberBtnClick
{
    NSInteger number= [self.numberTextField.text integerValue];
    if (number >= 1) {
        number -= 1;
        self.numberTextField.text  = [NSString stringWithFormat:@"%ld",number];
    }
}

- (void)addNumberBtnClick
{
    NSInteger number = [self.numberTextField.text integerValue];

    if (number < [self.productModel.stock integerValue]) {
        number += 1;
        self.numberTextField.text = [NSString stringWithFormat:@"%ld",number];
    }
}



- (void)showView
{
    
    CGRect frame = self.whiteBgView.frame;
    frame.origin.y = kScreenHeight/3;
    self.whiteBgView.frame = frame;
    
////    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//
//
//
//    } completion:^(BOOL finished) {
//    }];
}

- (void)hideView
{
    [self endEditing:YES];
    
    CGRect frame = self.whiteBgView.frame;
    frame.origin.y = kScreenHeight;
    self.whiteBgView.frame = frame;
    
    self.numberTextField.text = @"";
    [self removeFromSuperview];
    
//    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//
//
//
//    } completion:^(BOOL finished) {
//
//        self.numberTextField.text = @"";
//         [self removeFromSuperview];
//    }];
}

#pragma mark - private method

- (void)layoutWithAuto
{
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).mas_offset(20);
        make.width.height.mas_equalTo(100);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).mas_offset(20);
        make.bottom.equalTo(self.iconImage.mas_bottom);
        make.right.equalTo(self).mas_offset(-190);
        make.height.mas_equalTo(50);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_bottom).mas_offset(20);
        make.left.equalTo(self.iconImage);
        make.height.mas_equalTo(50);
    }];
    [self.unitTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.unitLabel);
        make.left.equalTo(self.unitLabel.mas_right).mas_offset(20);
        make.width.height.equalTo(self.unitLabel);
    }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.unitLabel.mas_bottom).mas_offset(10);
        make.left.equalTo(self.unitLabel);
        make.height.equalTo(self.unitLabel);
    }];
    [self.addNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberLabel).mas_offset(5);
        make.right.equalTo(self).mas_offset(-100);
        make.width.height.mas_equalTo(40);
    }];
    [self.numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.addNumberBtn);
        make.right.equalTo(self.addNumberBtn.mas_left);
        make.width.mas_equalTo(100);
    }];
    [self.reduceNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.addNumberBtn);
        make.right.equalTo(self.numberTextField.mas_left);
    }];
    [self.comppleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).mas_offset(-100);
        make.right.equalTo(self).mas_offset(-100);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(100);
    }];

}


#pragma mark - getter and setter

- (void)setDetailModel:(ProductDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    self.productModel = detailModel.product[ProductDetailProductKey];
    
    self.nameLabel.text = self.productModel.product_name;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:kSDYImageUrl(self.productModel.thumbnail)]];
    self.unitTextLable.text = self.productModel.unit;

}



- (UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.layer.borderWidth = 1;
        _iconImage.layer.borderColor = [[UIColor blackColor] CGColor];
//        [_iconImage sd_setImageWithURL:[NSURL URLWithString:@"http://pic23.photophoto.cn/20120530/0020033092420808_b.jpg"]];
    }
    return _iconImage;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithTextColor:nil font:18];
        _nameLabel.layer.borderWidth = 1;
        _nameLabel.layer.borderColor = [[UIColor blackColor] CGColor];
        _nameLabel.layer.cornerRadius = 10;
    }
    return _nameLabel;
}

- (UILabel *)unitLabel
{
    if (!_unitLabel) {
        _unitLabel = [UILabel labelWithTextColor:nil font:18];
        _unitLabel.text = @"单位 :";
        [_unitLabel sizeToFit];
    }
    return _unitLabel;
}

- (UILabel *)unitTextLable
{
    if (!_unitTextLable) {
        _unitTextLable = [UILabel labelWithTextColor:nil font:18];
    }
    return _unitTextLable;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [UILabel labelWithTextColor:nil font:18];
        _numberLabel.text = @"数量 :";
        [_numberLabel sizeToFit];
    }
    return _numberLabel;
}

- (UIButton *)reduceNumberBtn
{
    if (!_reduceNumberBtn) {
        _reduceNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reduceNumberBtn setImage:[UIImage imageNamed:@"subtract"] forState:UIControlStateNormal];
        [_reduceNumberBtn addTarget:self action:@selector(reduceNumberBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceNumberBtn;
}

- (UIButton *)addNumberBtn
{
    if (!_addNumberBtn) {
        _addNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addNumberBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [_addNumberBtn addTarget:self action:@selector(addNumberBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addNumberBtn;
}

- (UITextField *)numberTextField
{
    if (!_numberTextField) {
        _numberTextField = [[UITextField alloc] init];
        _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _numberTextField.font = [UIFont systemFontOfSize:18];
        _numberTextField.borderStyle = UITextBorderStyleRoundedRect;
        _numberTextField.textAlignment = NSTextAlignmentCenter;
        
    }
    return _numberTextField;
}

- (UIButton *)comppleteBtn
{
    if (!_comppleteBtn) {
        _comppleteBtn = [UIButton btnWithTitle:@"确定" font:18 textColor:[UIColor whiteColor] bgColor:kUIColorFromRGB(0x06ce8a)];
        [_comppleteBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
//        _comppleteBtn.layer.borderWidth = 0.5;
//        _comppleteBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    }
    return _comppleteBtn;
}

- (UIView *)whiteBgView
{
    if (!_whiteBgView) {
        _whiteBgView = [[UIView alloc] init];
        _whiteBgView.backgroundColor = kUIColorFromRGB(0xf0f0f0);
        //kUIColorFromRGB(0xf0f0f0);
    }
    return _whiteBgView;
}

@end
