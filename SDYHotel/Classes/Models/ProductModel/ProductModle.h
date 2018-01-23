//
//  ProductModle.h
//  SDYHotel
//
//  Created by admin on 2017/12/14.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Category.h"

@interface ProductModle : NSObject

//商品id
@property (nonatomic, copy) NSString *product_id;
//产品名称
@property (nonatomic, copy) NSString *product_name;
//缩略图网址
@property (nonatomic, copy) NSString *thumbnail;
//市场价格
@property (nonatomic, copy) NSString *market_price;
//商场价格
@property (nonatomic, copy) NSString *mall_price;
//库存
@property (nonatomic, copy) NSString *stock;
//销售
@property (nonatomic, copy) NSString *sales;
//显示销售  （最后显示scales + show_sales）
@property (nonatomic, copy) NSString *show_sales;


@end
