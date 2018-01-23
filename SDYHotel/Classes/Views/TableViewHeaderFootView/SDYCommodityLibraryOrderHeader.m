//
//  SDYCommodityLibraryOrderHeader.m
//  SDYHotel
//
//  Created by admin on 2017/12/30.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYCommodityLibraryOrderHeader.h"
#import "Masonry.h"



@interface SDYCommodityLibraryOrderHeader ()

@property (nonatomic) UILabel *productNameLabel;
@property (nonatomic) UILabel *shopNameLabel;
@property (nonatomic) UILabel *productNumberLabel;
@property (nonatomic) UILabel *productPricelLabel;

@end


@implementation SDYCommodityLibraryOrderHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.productNameLabel];
        [self.contentView addSubview:self.shopNameLabel];
        [self.contentView addSubview:self.productNumberLabel];
        [self.contentView addSubview:self.productPricelLabel];
    }
    return self;
}

#pragma mark - Getter and Setter

- (void)setTitlesAry:(NSArray *)titlesAry
{
    _titlesAry = titlesAry;
    
    self.productNameLabel.text = _titlesAry[0];
    self.shopNameLabel.text = titlesAry[1];
    self.productNumberLabel.text = titlesAry[2];
    self.productPricelLabel.text = titlesAry[3];
    
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(10);
    }];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.productNameLabel);
        make.left.equalTo(self.productNameLabel.mas_right).mas_offset(10);
    }];
    [self.productNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.shopNameLabel);
        make.left.equalTo(self.shopNameLabel.mas_right).mas_offset(10);
    }];
    [self.productPricelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.productNumberLabel);
        make.left.equalTo(self.productNumberLabel.mas_right).mas_offset(10);
        make.right.equalTo(self.contentView).mas_offset(-50);
    }];
    [self.productNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.productPricelLabel);
    }];
}

- (UILabel *)productNameLabel
{
    if (!_productNameLabel) {
        _productNameLabel = [self setupDefaultLabel];
    }
    return _productNameLabel;
}

- (UILabel *)shopNameLabel
{
    if (!_shopNameLabel) {
        _shopNameLabel = [self setupDefaultLabel];
    }
    return _shopNameLabel;
}

- (UILabel *)productNumberLabel
{
    if (!_productNumberLabel) {
        _productNumberLabel = [self setupDefaultLabel];
    }
    return _productNumberLabel;
}

- (UILabel *)productPricelLabel
{
    if (!_productPricelLabel) {
        _productPricelLabel = [self setupDefaultLabel];
    }
    return _productPricelLabel;
}

- (UILabel *)setupDefaultLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:kCellFont];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    return label;
}

@end
