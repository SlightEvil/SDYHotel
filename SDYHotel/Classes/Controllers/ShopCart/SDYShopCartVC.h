//
//  SDYShopCartVC.h
//  SDYHotel
//
//  Created by admin on 2017/12/29.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYBaseVC.h"

@interface SDYShopCartVC : SDYBaseVC

@end





@interface SDYShopCartShopModel : NSObject

/** 供应商id */
@property (nonatomic) NSString *shopID;
/** 供应商名称 */
@property (nonatomic) NSString *shopName;
/** 该供应商订单商品的的总价 */
@property (nonatomic) NSString *totalPrice;
/** 订单商品数组 */
@property (nonatomic) NSMutableArray *productAry;

@end

@interface SDYShopCartProductModel : NSObject

/** 商品名称 */
@property (nonatomic) NSString *productName;
/** 商品id */
@property (nonatomic) NSString *productID;
/** 数量 */
@property (nonatomic) NSString *quantity;
/** 属性，单价 级别 */
@property (nonatomic) NSString *attributes;
/** 价格 */
@property (nonatomic) NSString *price;

@end


