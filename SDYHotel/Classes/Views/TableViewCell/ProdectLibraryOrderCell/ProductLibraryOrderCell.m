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

/** 商品名 */
@property (nonatomic) UILabel *productNameLabel;
/** 价格 */
@property (nonatomic) UILabel *shopNameLabel;
/** 数量 */
@property (nonatomic) UILabel *productNumberLabel;
/** 小计 */
@property (nonatomic) UILabel *productPricelLabel;
/** 删除 */
@property (nonatomic) UIButton *deleteBtn;

@property (nonatomic, copy) void(^deleteClick)(void);


@end

@implementation ProductLibraryOrderCell
{
    CGFloat _width;
    
}

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
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).mas_offset(-10);
        make.width.height.mas_equalTo(30);
    }];
    
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
        make.right.equalTo(self.deleteBtn.mas_left).mas_offset(-10);
    }];
    [self.productNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.productPricelLabel);
    }];
}

#pragma mark - Getter and Setter

- (void)setShopCartModel:(ProductShopCartModel *)shopCartModel
{
    _shopCartModel = shopCartModel;
    
//    NSString *numberStr = [NSString stringWithFormat:@"%d",_shopCartModel.number];
//    NSString *unitStr = _shopCartModel.attributes;
    self.productNameLabel.text = _shopCartModel.productName;
//    self.shopNameLabel.text = _shopCartModel.shopName;
//    self.productNumberLabel.text = [NSString stringWithFormat:@"%@ * %@",unitStr,numberStr];
//    self.productPricelLabel.text = [NSString stringWithFormat:@"%.2f",_shopCartModel.unitPrice];//保留2位小数
//
    //[NSString stringWithFormat:@"%.2f",_shopCartModel.unitPrice];
    
    self.shopNameLabel.text = _shopCartModel.attributes;
    self.productNumberLabel.text = [NSString stringWithFormat:@"%.2f*%d",_shopCartModel.unitPrice,_shopCartModel.number];
    self.productPricelLabel.text = _shopCartModel.toalPrice;

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

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UILabel *)setupDefaultLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:kCellFont];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 3;
    label.minimumScaleFactor = 0.7;
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}

@end
