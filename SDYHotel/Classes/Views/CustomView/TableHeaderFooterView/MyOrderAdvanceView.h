//
//  MyOrderAdvanceView.h
//  SDYHotel
//
//  Created by admin on 2018/1/4.
//  Copyright © 2018年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderOrderListModel;

@interface MyOrderAdvanceView : UIView

/** 单个订单详情 */
@property (nonatomic) MyOrderOrderListModel *listModel;

- (instancetype)initWithAdvanceFrame:(CGRect)frame;

- (instancetype)initWithPostFrame:(CGRect)frame compleBlock:(void(^)(void))block;

@end
