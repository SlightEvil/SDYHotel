//
//  ProductDetailModel.h
//  SDYHotel
//
//  Created by admin on 2017/12/14.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Category.h"


FOUNDATION_EXPORT NSString *const ProductDetailProductKey;

@interface ProductDetailModel : NSObject


@property (nonatomic) NSMutableArray *attributes;

@property (nonatomic) NSMutableDictionary *product;

@property (nonatomic) NSMutableArray *shops;

@property (nonatomic) NSMutableArray *skus;

@end


#pragma mark - 一个.h 文件中创建多个 @interface ，需要在.m 文件中 创建多个@implementation

static NSString *const attributesNameKey = @"attribute_name";
static NSString *const attributesIdKey = @"attribute_id";

// 产品规格信息
@interface ProductDetailAttributesModel : NSObject

//规格分组名称
@property (nonatomic) NSString *group_name;

//规格名称
@property (nonatomic) NSString *attribute_name;
//单品id
@property (nonatomic) NSString *sku_id;
//单品库存
@property (nonatomic) NSString *stock;
//单品销量
@property (nonatomic) NSString *sales;
//销量基数
@property (nonatomic) NSString *show_sales;
//级别
@property (nonatomic) NSMutableArray *attributes;

@end


//@{}
@interface ProductDetailProductModel : NSObject

//计量单位
@property (nonatomic) NSString *unit;
//产品名称
@property (nonatomic) NSString *product_name;
//产品副名称
@property (nonatomic) NSString *product_sub_name;
//描述
@property (nonatomic) NSString *product_description;
//分类id
@property (nonatomic) NSString *category_id;
//商场价格
@property (nonatomic) NSString *mall_price;
//商店名字
@property (nonatomic) NSString *shop_name;
//库存
@property (nonatomic) NSString *stock;
//是否上架
@property (nonatomic) NSString *is_on_sale;
//市场价格
@property (nonatomic) NSString *market_price;
//产品ID
@property (nonatomic) NSString *product_id;
//是否推荐
@property (nonatomic) NSString *is_recommand;
//是否首页显示
@property (nonatomic) NSString *show_index;
//缩略图
@property (nonatomic) NSString *thumbnail;
//销售
@property (nonatomic) NSString *sales;
//销售基数
@property (nonatomic) NSString *show_sales;
//商店id
@property (nonatomic) NSString *shop_id;

@end


//@[ @{ }  ]
@interface ProductDetailShopModel : NSObject

//电话号码
@property (nonatomic) NSString *phone;
//地址
@property (nonatomic) NSString *address;
//商店内容
@property (nonatomic) NSString *shop_content;
//email
@property (nonatomic) NSString *email;
//商店的用户ID
@property (nonatomic) NSString *user_id;
//商店名字
@property (nonatomic) NSString *shop_name;
//shop_id
@property (nonatomic) NSString *shop_id;
//手机号码
@property (nonatomic) NSString *master_phone;

@end


//@[ @{ } ]
@interface ProductDetailSkusModel : NSObject

/** 单品id */
@property (nonatomic) NSString *sku_id;
/** 产品ID */
@property (nonatomic) NSString *product_id;
/** 商场价格 */
@property (nonatomic) NSString *mall_price;
//销售
@property (nonatomic) NSString *sales;
//创建时间
@property (nonatomic) NSString *created_at;
//市场价格
@property (nonatomic) NSString *market_price;
//库存
@property (nonatomic) NSString *stock;
//属性
@property (nonatomic) NSString *attributes;
/** 规格名称 */
@property (nonatomic) NSString *attribute_names;

//显示销售
@property (nonatomic) NSString *show_sales;
//产品名字
@property (nonatomic) NSString *product_name;
/** 规格的数组 用来根据规格数字显示规格 */
@property (nonatomic) NSArray *attributeArray;

@end



