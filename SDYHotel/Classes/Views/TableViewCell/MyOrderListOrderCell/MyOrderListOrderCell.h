//
//  MyOrderListOrderCell.h
//  SDYHotel
//
//  Created by admin on 2017/12/22.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderOrderDetailModel;

@interface MyOrderListOrderCell : UITableViewCell

@property (nonatomic) MyOrderOrderDetailModel *orderDetailModel;


@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;


@end
