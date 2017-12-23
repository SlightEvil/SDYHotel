//
//  ProductCollectionCell.m
//  SDYHotel
//
//  Created by admin on 2017/12/23.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ProductCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProductModle.h"

@implementation ProductCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setProductModel:(ProductModle *)productModel
{
    _productModel = productModel;
    self.productName.text = _productModel.product_name;
    self.stock.text = [NSString stringWithFormat:@"库存:%@",_productModel.stock];
    self.productPrice.text = _productModel.mall_price;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:kSDYImageUrl(_productModel.thumbnail)] placeholderImage:[UIImage imageNamed:@"icon_close"]];
}

@end
