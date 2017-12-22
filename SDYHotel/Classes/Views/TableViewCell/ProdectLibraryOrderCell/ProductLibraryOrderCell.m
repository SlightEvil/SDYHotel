//
//  ProdectLibraryOrderCell.m
//  SDYHotel
//
//  Created by admin on 2017/12/17.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ProductLibraryOrderCell.h"
#import "UILabel+Category.h"
#import "Masonry.h"
#import "ProductShopCartModel.h"

@interface ProductLibraryOrderCell ()

@property (nonatomic) UILabel *productNameLabel;
@property (nonatomic) UILabel *shopNameLabel;
@property (nonatomic) UILabel *productNumberLabel;
@property (nonatomic) UILabel *productPricelLabel;

@property (nonatomic) UIButton *deleteBtn;

@property (nonatomic, copy) void(^deleteClick)(void);


@end

@implementation ProductLibraryOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.productNameLabel];
        [self.contentView addSubview:self.shopNameLabel];
        [self.contentView addSubview:self.productNumberLabel];
        [self.contentView addSubview:self.productPricelLabel];
        
        [self.contentView addSubview:self.deleteBtn];
        
        [self layoutWithAuto];
    }
    return self;
}

- (void)cellDeleteBtnClick:(void (^)(void))deleteBlock
{
    self.deleteClick = deleteBlock;
}

#pragma mark - Event response

- (void)deleteBtnClick {
 
    if (self.deleteClick) {
        self.deleteClick();
    }
}


#pragma mark - Private method

- (void)layoutWithAuto
{
//    480310 - 300
//    120*3
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(30);
        make.right.equalTo(self).mas_offset(-20);
    }];
    [self.productPricelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.deleteBtn);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.deleteBtn.mas_left).mas_offset(-10);
        make.width.mas_equalTo(95);
    }];
    [self.productNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.productPricelLabel);
        make.right.equalTo(self.productPricelLabel.mas_left).mas_offset(-10);
    }];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.productNumberLabel);
        make.right.equalTo(self.productNumberLabel.mas_left).mas_offset(-10);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.shopNameLabel);
        make.right.equalTo(self.shopNameLabel.mas_left).mas_offset(-10);
//        make.left.equalTo(self.contentView).mas_offset(10);
    }];
}

#pragma mark - Getter and Setter

- (void)setShopCartModel:(ProductShopCartModel *)shopCartModel
{
    _shopCartModel = shopCartModel;
    
    if (_shopCartModel.isSection) {
        self.productNameLabel.text = @"商品名称";
        self.shopNameLabel.text = @"供货商";
        self.productNumberLabel.text = @"常用量";
        self.productPricelLabel.text = @"参考价";
        self.deleteBtn.hidden = YES;
        
    } else {
        self.productNameLabel.text = _shopCartModel.productName;
        self.shopNameLabel.text = _shopCartModel.shopName;
        
        NSString *numberStr = [NSString stringWithFormat:@"%d",_shopCartModel.number];
        NSString *unitStr = _shopCartModel.attributes;
        
        self.productNumberLabel.text = [NSString stringWithFormat:@"%@ * %@",unitStr,numberStr];
        self.productPricelLabel.text = [NSString stringWithFormat:@"%.2f",_shopCartModel.unitPrice];//保留2位小数
        self.deleteBtn.hidden = NO;
    }
}


- (UILabel *)productNameLabel
{
    if (!_productNameLabel) {
        _productNameLabel = [UILabel labelWithTextColor:nil font:16];
        _productNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _productNameLabel;
}

- (UILabel *)shopNameLabel
{
    if (!_shopNameLabel) {
        _shopNameLabel = [UILabel labelWithTextColor:nil font:16];
        _shopNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _shopNameLabel;
}

- (UILabel *)productNumberLabel
{
    if (!_productNumberLabel) {
        _productNumberLabel = [UILabel labelWithTextColor:nil font:16];
        _productNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _productNumberLabel;
}

- (UILabel *)productPricelLabel
{
    if (!_productPricelLabel) {
        _productPricelLabel = [UILabel labelWithTextColor:nil font:16];
        _productPricelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _productPricelLabel;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end
