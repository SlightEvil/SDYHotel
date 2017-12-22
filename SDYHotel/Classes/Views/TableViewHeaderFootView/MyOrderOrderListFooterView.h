//
//  MyOrderOrderListFooterView.h
//  SDYHotel
//
//  Created by admin on 2017/12/22.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderOrderListModel;

@interface MyOrderOrderListFooterView : UITableViewHeaderFooterView

@property (nonatomic, assign) BOOL isPostOrder;
@property (nonatomic) MyOrderOrderListModel *footerModel;


@end
