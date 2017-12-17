//
//  ProdectLibraryOrderCell.m
//  SDYHotel
//
//  Created by admin on 2017/12/17.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ProdectLibraryOrderCell.h"
#import "UILabel+Category.h"
#import "Masonry.h"

@interface ProdectLibraryOrderCell ()

@property (nonatomic) UILabel *productNameLabel;
@property (nonatomic) UILabel *shopNameLabel;
@property (nonatomic) UILabel *productNumberLabel;

@property (nonatomic) UIButton *deleteBtn;

@end

@implementation ProdectLibraryOrderCell

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
        [self.contentView addSubview:self.deleteBtn];
        
        [self layoutWithAuto];
    }
    return self;
}

#pragma mark - Private method

- (void)layoutWithAuto
{
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
    }];
}


#pragma mark - Getter and Setter

- (UILabel *)productNameLabel
{
    if (!_productNameLabel) {
        _productNameLabel = [UILabel labelWithTextColor:nil font:16];
    }
    return _productNameLabel;
}

- (UILabel *)shopNameLabel
{
    if (!_shopNameLabel) {
        _shopNameLabel = [UILabel labelWithTextColor:nil font:16];
    }
    return _shopNameLabel;
}

- (UILabel *)productNumberLabel
{
    if (!_productNumberLabel) {
        _productNumberLabel = [UILabel labelWithTextColor:nil font:16];
    }
    return _productNumberLabel;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _deleteBtn;
}

- (IBAction)deleteBtn:(id)sender {
    
}
@end
