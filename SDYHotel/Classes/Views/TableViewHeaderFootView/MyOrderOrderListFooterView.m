//
//  MyOrderOrderListFooterView.m
//  SDYHotel
//
//  Created by admin on 2017/12/22.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "MyOrderOrderListFooterView.h"
#import "UILabel+Category.h"
#import "UIView+Category.h"

#import "MyOrderOrderListModel.h"

@interface MyOrderOrderListFooterView ()

/**
 订单标号
 */
@property (nonatomic) UILabel *order_noLabel;
@property (nonatomic) UILabel *order_no;
/**
 订单状态
 */
@property (nonatomic) UILabel *orderStatusLabel;
@property (nonatomic) UILabel *orderStatus;
/**
 订单创建时间
 */
@property (nonatomic) UILabel *orderCreateLabel;
@property (nonatomic) UILabel *orderCreate;
/**
 订单备注
 */
@property (nonatomic) UILabel *orderRemarkLabel;
@property (nonatomic) UILabel *orderRemark;
/**
 订单总价
 */
@property (nonatomic) UILabel *orderTotalPriceLable;
@property (nonatomic) UILabel *orderTotalPrice;

@end

@implementation MyOrderOrderListFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat width = (kScreenWidth - 200)/2;
        
        [self.contentView addSubview:self.order_no];
        [self.contentView addSubview:self.orderTotalPrice];
        [self.contentView addSubview:self.orderStatus];
        [self.contentView addSubview:self.orderCreate];
        [self.contentView addSubview:self.orderRemark];
        
        [self.contentView addSubview:self.orderTotalPriceLable];
        [self.contentView addSubview:self.order_noLabel];
        [self.contentView addSubview:self.orderStatusLabel];
        [self.contentView addSubview:self.orderCreateLabel];
        [self.contentView addSubview:self.orderRemarkLabel];
        
        
        self.orderTotalPrice.frame = CGRectMake(10, 0, self.orderTotalPrice.width, 40);
        self.orderTotalPriceLable.frame = CGRectMake(self.orderTotalPrice.width+10, 0, width - self.orderTotalPrice.width-20, 40);
        
        self.order_no.frame = CGRectMake(10, 40, self.order_no.width, 40);
        self.order_noLabel.frame = CGRectMake(self.order_no.width+10, 40, width - self.order_no.width-20, 40);
        
        self.orderStatus.frame = CGRectMake(10, 80, self.orderStatus.width, 40);
        self.orderStatusLabel.frame = CGRectMake(self.orderStatus.width+10, 80, width - self.orderStatus.width-20, 40);
        
        self.orderCreate.frame = CGRectMake(10, 120, self.orderCreate.width, 40);
        self.orderCreateLabel.frame = CGRectMake(self.orderCreate.width+10, 120, width - self.orderCreate.width-20, 40);
        
        self.orderRemark.frame = CGRectMake(10, 160, self.orderRemark.width, 40);
        self.orderRemarkLabel.frame = CGRectMake(self.orderRemark.width+10, 160, width - self.orderRemark.width-20, 40);
    
    }
    return self;
}


#pragma mark - pricate method




#pragma mark - Getter and Setter

- (void)setFooterModel:(MyOrderOrderListModel *)footerModel
{
    _footerModel = footerModel;
    
    self.orderTotalPriceLable.text = self.isPostOrder ? _footerModel.post_price : _footerModel.price;
    self.order_noLabel.text = _footerModel.order_no;
    self.orderCreateLabel.text = _footerModel.created_at;
    self.orderRemarkLabel.text = _footerModel.content;
    
    switch ([_footerModel.status intValue]) {
        case 0:
            self.orderStatusLabel.text = @"未查阅";
            break;
        case 1:
            self.orderStatusLabel.text = @"未处理";
            break;
        case 2:
            self.orderStatusLabel.text = @"已处理";
            break;
            //0 未查阅 1 未处理 2 已处理
        default:
            break;
    }
}

- (UILabel *)labelWithTitle:(NSString *)title font:(CGFloat)font
{
    UILabel *label = [UILabel labelWithTextColor:nil font:font];
    label.text = title;
    [label sizeToFit];
    return label;
}


- (UILabel *)order_no
{
    if (!_order_no) {
        _order_no = [self labelWithTitle:@"订单编号：" font:18];
    }
    return _order_no;
}
- (UILabel *)order_noLabel
{
    if (!_order_noLabel) {
        _order_noLabel = [UILabel labelWithTextColor:nil font:18];
        _order_noLabel.textAlignment = NSTextAlignmentRight;
    }
    return _order_noLabel;
}

- (UILabel *)orderStatus
{
    if (!_orderStatus) {
        _orderStatus = [self labelWithTitle:@"订单状态：" font:18];
    }
    return _orderStatus;
}
- (UILabel *)orderStatusLabel
{
    if (!_orderStatusLabel) {
        _orderStatusLabel = [UILabel labelWithTextColor:nil font:18];
        _orderStatusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _orderStatusLabel;
}

- (UILabel *)orderCreate
{
    if (!_orderCreate) {
        _orderCreate = [self labelWithTitle:@"下单时间：" font:18];
    }
    return _orderCreate;
}
- (UILabel *)orderCreateLabel
{
    if (!_orderCreateLabel) {
        _orderCreateLabel = [UILabel labelWithTextColor:nil font:18];
        _orderCreateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _orderCreateLabel;
}

- (UILabel *)orderRemark
{
    if (!_orderRemark) {
        _orderRemark = [self labelWithTitle:@"备注：" font:18];
    }
    return _orderRemark;
}
- (UILabel *)orderRemarkLabel
{
    if (!_orderRemarkLabel) {
        _orderRemarkLabel = [UILabel labelWithTextColor:nil font:18];
        _orderRemarkLabel.textAlignment = NSTextAlignmentRight;
    }
    return _orderRemarkLabel;
}

- (UILabel *)orderTotalPrice
{
    if (!_orderTotalPrice) {
        _orderTotalPrice = [self labelWithTitle:@"总价：" font:18];
    }
    return _orderTotalPrice;
}
- (UILabel *)orderTotalPriceLable
{
    if (!_orderTotalPriceLable) {
        _orderTotalPriceLable = [UILabel labelWithTextColor:nil font:18];
        _orderTotalPriceLable.textAlignment = NSTextAlignmentRight;
    }
    return _orderTotalPriceLable;
}





@end
