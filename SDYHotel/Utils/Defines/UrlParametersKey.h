//
//  UrlParametersKey.h
//  SDYHotel
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#ifndef UrlParametersKey_h
#define UrlParametersKey_h

//用户
static NSString *const user_name =          @"user_name";
//密码
static NSString *const user_password =      @"user_password";
//用户ID
static NSString *const user_id =            @"user_id";

//内容
static NSString *const content =            @"content";
//订单ID
static NSString *const orderId =            @"id";

//当前页码
static NSString *const page =               @"p";
//每页行数
static NSString *const line =               @"len";

//商品列表
//商品分类ID
static NSString *const cat =                @"cat";
//商品名称
static NSString *const name =               @"name";
//父级分类ID
static NSString *const pid =                @"pid";
//商品id
static NSString *const productID =          @"id";

//此shop_id为当前用户（供应商）所属的店铺id
static NSString *const shop_id =            @"shop_id";
//此order_id正式从订单列表接口拿到的order_id
static NSString *const order_id =           @"order_id";

static NSString *const shop_name =          @"shop_name";
//供应商号码
static NSString *const shop_phone =         @"shop_phone";

//
static NSString *const detail_id =          @"detail_id";
//单品id
static NSString *const sku_id =             @"sku_id";

static NSString *const product_id =         @"product_id";

static NSString *const attributes =         @"attributes";

static NSString *const quantity =           @"quantity";


static NSString *const status =             @"status";

static NSString *const message =            @"message";




#endif /* UrlParametersKey_h */
