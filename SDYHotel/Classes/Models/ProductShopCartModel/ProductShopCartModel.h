//
//  ProductShopCartModel.h
//  SDYHotel
//
//  Created by admin on 2017/12/19.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Category.h"
#import "ProductDetailModel.h"


#pragma mark - 订单

@interface ProductShopCartDetailModel: NSObject

//更新的时候用到
@property (nonatomic) NSString *detail_id;
//
@property (nonatomic) NSString *sku_id;
//商品名称
@property (nonatomic) NSString *product_name;
//商品ID
@property (nonatomic) NSString *product_id;
//属性
@property (nonatomic) NSString *attributes;
//单价
@property (nonatomic) NSString *price;
//数量
@property (nonatomic) NSString *quantity;
//单位  eg 斤
@property (nonatomic) NSString *unit;

@end


@interface ProductOrderModel : NSObject

//供应商ID
@property (nonatomic) NSString *shopID;
//供应商名称
@property (nonatomic) NSString *shopName;
//供应商电话
@property (nonatomic) NSString *shopPhone;
//登录用户的ID
@property (nonatomic) NSString *userID;
//登录用户的name
@property (nonatomic) NSString *userName;
//总价
@property (nonatomic) NSString *totalPrice;
//备注
@property (nonatomic) NSString *content;
//详细
@property (nonatomic) NSMutableArray *details;


@end


/**
 订单里面  商品详情model
 */
@interface ProductOrderDetailModel : NSObject

@property (nonatomic) NSString *detail_id;
@property (nonatomic) NSString *sku_id;
@property (nonatomic) NSString *product_name;
@property (nonatomic) NSString *product_id;
@property (nonatomic) NSString *attributes;
@property (nonatomic) NSString *mall_price;
@property (nonatomic) NSString *quantity;
@property (nonatomic) NSString *unit;
@property (nonatomic) NSString *market_price;

@end



#pragma mark - 购物车

/**
 购物车
 */
@interface ProductShopCartModel : NSObject


//商品名称
@property (nonatomic) NSString *productName;
//供应商
@property (nonatomic) NSString *shopName;
//总价
@property (nonatomic,readonly) NSString *toalPrice;

//数量
@property (nonatomic, assign) int number;
//单价
@property (nonatomic, assign) float unitPrice;
//单位 eg：斤
@property (nonatomic) NSString *unit;
//属相  eg 级别，单价
@property (nonatomic ) NSString *attributes;

//是否为第一行
@property (nonatomic, assign) BOOL isSection;

/**
 单品数据
 */
@property (nonatomic) ProductDetailSkusModel *skusModel;

/**
 供应商数据
 */
@property (nonatomic) ProductDetailShopModel *shopModel;

///**
// 提交订单的时候，保存 相同商品相同商家的 商品
// */
//@property (nonatomic) NSMutableArray *detailArray;

@end
