//
//  ProductCollectionCell.m
//  SDYHotel
//
//  Created by admin on 2017/12/23.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ProductCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "ProductDetailModel.h"


@implementation ProductCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *selectView = [[UIView alloc] init];
    selectView.frame = self.bounds;
    selectView.backgroundColor = kSDYSelectColor;
    self.selectedBackgroundView = selectView;
    
   
    
    // Initialization code
}

- (void)setProductModel:(ProductDetailProductModel *)productModel
{
    _productModel = productModel;
    self.productName.text = _productModel.product_name;
    self.stock.text = [NSString stringWithFormat:@"库存:%@",_productModel.stock];
    self.productPrice.text = _productModel.mall_price;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:kSDYImageUrl(_productModel.thumbnail)] placeholderImage:[UIImage imageNamed:@"icon_error"]];
}

@end
