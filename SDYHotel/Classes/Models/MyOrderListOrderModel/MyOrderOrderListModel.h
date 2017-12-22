//
//  MyOrderOrderListModel.h
//  SDYHotel
//
//  Created by admin on 2017/12/21.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Category.h"


///**
// 根据时间添加model
// */
//@interface MyOrderOrderListTimeModel: NSObject
//
//@property (nonatomic) NSString *time;
//
//@property (nonatomic) NSMutableArray *orderListArray;
//
//@end

/**
 订单列表 section
 */
@interface MyOrderOrderListModel : NSObject

/**
 是否展开
 */
@property (nonatomic, assign) BOOL isExpanded;

/**
 订单id
 */
@property (nonatomic) NSString *order_id;

/**
 供应商
 */
@property (nonatomic) NSString *shop_name;

/**
 订单号
 */
@property (nonatomic) NSString *order_no;

/**
 创建时间
 */
@property (nonatomic) NSString *created_at;

/**
 预订单数组 MyOrderOrderDetailModel
 */
@property (nonatomic) NSMutableArray *details;

/**
 配送单数组 MyOrderOrderDetailModel
 */
@property (nonatomic) NSMutableArray *post_details;

/**
 预订单总价
 */
@property (nonatomic) NSString *price;

/**
 配送单总价
 */
@property (nonatomic) NSString *post_price;

/**
 订单状态
 */
@property (nonatomic) NSString *status;

/**
 备注
 */
@property (nonatomic) NSString *content;


@end




/**
 预订单 配送单 数据
 */
@interface MyOrderOrderDetailModel : NSObject

/**
 详情id  更新订单的时候需要
 */
@property (nonatomic) NSString *detail_id;

/**
 订单id
 */
@property (nonatomic) NSString *order_id;

/**
 商品名称
 */
@property (nonatomic) NSString *product_name;

/**
 单价
 */
@property (nonatomic) NSString *price;

/**
 数量
 */
@property (nonatomic) NSString *quantity;

/**
 总价
 */
@property (nonatomic) NSString *total_price;



@end

