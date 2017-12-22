//
//  ProductOrderCartTableFootView.m
//  SDYHotel
//
//  Created by admin on 2017/12/20.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ProductOrderCartTableFootView.h"
#import "UIButton+Category.h"
#import "Masonry.h"


@interface ProductOrderCartTableFootView ()

@property (nonatomic) UITextView *remarkTextView;

@property (nonatomic) UIButton *placeOrderBtn;

@end


@implementation ProductOrderCartTableFootView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kUIColorFromRGB(0xf0f0f0);
        [self addSubview:self.remarkTextView];
        [self addSubview:self.placeOrderBtn];
        
        [self.placeOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(10);
            make.bottom.equalTo(self).mas_offset(-10);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(100);
        }];
        [self.remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).mas_offset(10);
            make.bottom.equalTo(self.placeOrderBtn.mas_top).mas_equalTo(-10);
            make.left.equalTo(self).mas_offset(10);
             make.right.equalTo(self).mas_offset(-10);
        }];
    }
    return self;
}


#pragma mark - Event response

- (void)placeOrderBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(placeOrderClickWithRemarkStr:)]) {
        [self.delegate placeOrderClickWithRemarkStr:self.remarkTextView.text];
    }
}

#pragma mark - Getter and Setter

- (UITextView *)remarkTextView
{
    if (!_remarkTextView) {
        _remarkTextView = [[UITextView alloc] init];
        _remarkTextView.font = [UIFont systemFontOfSize:18];
        _remarkTextView.textColor = kUIColorFromRGB(0X878787);
        _remarkTextView.textAlignment = NSTextAlignmentLeft;
        _remarkTextView.text = @"备注：";
    }
    return _remarkTextView;
}

- (UIButton *)placeOrderBtn
{
    if (!_placeOrderBtn) {
        _placeOrderBtn = [UIButton btnWithTitle:@"下单" font:18 textColor:nil bgColor:kUIColorFromRGB(0x06ce8a)];
        [_placeOrderBtn addTarget:self action:@selector(placeOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _placeOrderBtn;
}



@end
