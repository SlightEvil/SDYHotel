//
//  SDYProductDetailAttrivuteCell.m
//  SDYHotel
//
//  Created by admin on 2017/12/30.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYProductDetailAttrivuteCell.h"
#import "Masonry.h"
#import "ProductDetailModel.h"

@interface SDYProductDetailAttrivuteCell ()

/** 选择属性 */
@property (nonatomic) UIButton *attributeSelectBtn;
/** 商家价格 */
@property (nonatomic) UILabel *mallPriceLabel;
/** 市场价格 */
@property (nonatomic) UILabel *maketPriceLabel;


@end

@implementation SDYProductDetailAttrivuteCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.attributeSelectBtn];
        [self.contentView addSubview:self.mallPriceLabel];
        [self.contentView addSubview:self.maketPriceLabel];
    
        [self layoutWithAuto];
    }
    return self;
}

#pragma mark - Event response

- (void)attributeBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    [button setBackgroundColor: button.selected ? kSDYAttributeSelectColor : [UIColor clearColor]];
    
    if (self.attributeBtnClick) {
        self.attributeBtnClick(self.index);
    }
}


#pragma mark - Private methods

- (void)layoutWithAuto
{
    [self.attributeSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).mas_offset(20);
        make.width.mas_equalTo(150);
    }];
    [self.mallPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.equalTo(self.attributeSelectBtn);
        make.left.equalTo(self.attributeSelectBtn.mas_right).mas_offset(20);
    }];
    [self.maketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.width.equalTo(self.mallPriceLabel);
        make.left.equalTo(self.mallPriceLabel.mas_right).mas_offset(20);
        make.right.equalTo(self);
    }];
}

/**
 传递规格number 返回规格名称
 
 @param attribute 规格字符串
 @param attributeAry 规格数组
 @return 规格名称
 */
- (NSString *)attributeWithAttributeNumber:(NSString *)attribute attributeAry:(NSArray *)attributeAry
{
    __block NSString *value1 = @"";
    __block  NSString *value2 = @"";
    
    NSArray *ary  = [attribute componentsSeparatedByString:@","];
      
    
    [attributeAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ProductDetailAttributesModel *attributesModle = obj;
        
        [attributesModle.attributes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dic = obj;
            if ([ary[0] isEqualToString:dic[attributesIdKey]]) {
                value1 = dic[attributesNameKey];
            }
            if ([ary[1] isEqualToString:dic[attributesIdKey]]) {
                value2 = dic[attributesNameKey];
            }
        }];
    }];
    
    return [NSString stringWithFormat:@"%@,%@",value1,value2];
}


#pragma mark - Getter and Setter

//- (void)setModel:(ProductDetailSkusModel *)model
//{
//    _model = model;
//
//    [self.attributeSelectBtn setTitle:[self attributeWithAttributeNumber:model.attributes attributeAry:self.attributeArray] forState:UIControlStateNormal];
//    self.mallPriceLabel.text = [NSString stringWithFormat:@"¥ %@",_model.mall_price];
//    //添加中划线
//    NSDictionary *attributeDic = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    NSMutableAttributedString *atttibuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@",_model.market_price] attributes:attributeDic];
//    self.maketPriceLabel.attributedText = atttibuteString;
//}

- (void)setAttribute:(NSString *)attribute
{
    _attribute = attribute;
    [self.attributeSelectBtn setTitle:_attribute forState:UIControlStateNormal];
}
- (void)setMallPrice:(NSString *)mallPrice
{
    _mallPrice = mallPrice;
    self.mallPriceLabel.text = [NSString stringWithFormat:@"¥ %@元/%@",_mallPrice,self.productUnit];
}
- (void)setMakePrice:(NSString *)makePrice
{
    _makePrice = makePrice;
    //添加中划线
    NSDictionary *attributeDic = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *atttibuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@元/%@",_makePrice,self.productUnit] attributes:attributeDic];
    self.maketPriceLabel.attributedText = atttibuteString;
}


- (void)setButtonIsSelected:(BOOL)buttonIsSelected
{
    _buttonIsSelected = buttonIsSelected;
    
    self.attributeSelectBtn.selected = _buttonIsSelected;
    
    [self.attributeSelectBtn setBackgroundColor: self.attributeSelectBtn.selected ? kSDYAttributeSelectColor : [UIColor clearColor]];
}

- (UIButton *)attributeSelectBtn
{
    if (!_attributeSelectBtn) {
        _attributeSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attributeSelectBtn.layer.masksToBounds = YES;
        _attributeSelectBtn.layer.cornerRadius = 10;
        _attributeSelectBtn.layer.borderWidth = 0.5;
        _attributeSelectBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [_attributeSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_attributeSelectBtn addTarget:self action:@selector(attributeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
          [_attributeSelectBtn setBackgroundColor: _attributeSelectBtn.selected ? kSDYAttributeSelectColor : [UIColor clearColor]];
    }
    return _attributeSelectBtn;
}

- (UILabel *)mallPriceLabel
{
    if (!_mallPriceLabel) {
        _mallPriceLabel = [[UILabel alloc] init];
        _mallPriceLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:17];
        _mallPriceLabel.textColor = [UIColor redColor];
    }
    return _mallPriceLabel;
}

- (UILabel *)maketPriceLabel
{
    if (!_maketPriceLabel) {
        _maketPriceLabel = [[UILabel alloc] init];
        _maketPriceLabel.font = [UIFont systemFontOfSize:15];
        _maketPriceLabel.textColor = [UIColor grayColor];
    }
    return _maketPriceLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
