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


@interface ProductOrderCartTableFootView ()<UITextViewDelegate>

/** 备注 */
@property (nonatomic) UITextView *remarkTextView;
/** 下单 */
@property (nonatomic) UIButton *placeOrderBtn;
/** 总价 */
@property (nonatomic) UILabel *totalPriceLabel;

@end


@implementation ProductOrderCartTableFootView


//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = kUIColorFromRGB(0xf0f0f0);
//        [self addSubview:self.remarkTextView];
//        [self addSubview:self.placeOrderBtn];
//
//        [self.placeOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).mas_offset(10);
//            make.bottom.equalTo(self).mas_offset(-10);
//            make.height.mas_equalTo(40);
//            make.width.mas_equalTo(100);
//        }];
//        [self.remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.equalTo(self).mas_offset(10);
//            make.bottom.equalTo(self.placeOrderBtn.mas_top).mas_equalTo(-10);
//            make.left.equalTo(self).mas_offset(10);
//            make.right.equalTo(self).mas_offset(-10);
//        }];
//    }
//    return self;
//}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kUIColorFromRGB(0xf0f0f0);
        [self addSubview:self.remarkTextView];
        [self addSubview:self.placeOrderBtn];
        [self addSubview:self.totalPriceLabel];
        
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
        [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.placeOrderBtn);
            make.left.equalTo(self.placeOrderBtn.mas_right).mas_offset(10);
            make.right.equalTo(self).mas_offset(-10);
        }];
    }
    return self;
}

#pragma mark - Event response

- (void)placeOrderBtnClick
{
    if (self.downOrderButtonClick) {
        self.downOrderButtonClick(self.remarkTextView.text);
        if (APPCT.isLogin) {
            self.orderTotalPrice = @"0.0";
        }
    }
}

#pragma mark - Delegate
/** UITextView 使用keyboard return键 关闭键盘 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - Getter and Setter

- (void)setOrderTotalPrice:(NSString *)orderTotalPrice
{
    _orderTotalPrice = orderTotalPrice;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计¥ %@",_orderTotalPrice];
}

- (UITextView *)remarkTextView
{
    if (!_remarkTextView) {
        _remarkTextView = [[UITextView alloc] init];
        _remarkTextView.font = [UIFont systemFontOfSize:18];
        _remarkTextView.textColor = kUIColorFromRGB(0X878787);
        _remarkTextView.textAlignment = NSTextAlignmentLeft;
        _remarkTextView.text = @"备注：";
        _remarkTextView.returnKeyType = UIReturnKeyDone;
        _remarkTextView.delegate = self;
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

- (UILabel *)totalPriceLabel
{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:kCellFont];
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
        _totalPriceLabel.textColor = [UIColor redColor];
        _totalPriceLabel.text = @"总计：0.0";
     
    }
    return _totalPriceLabel;
}


@end
