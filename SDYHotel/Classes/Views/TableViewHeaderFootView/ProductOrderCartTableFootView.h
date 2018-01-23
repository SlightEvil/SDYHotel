//
//  ProductOrderCartTableFootView.h
//  SDYHotel
//
//  Created by admin on 2017/12/20.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DownOrderButtonClick)(NSString *remark);


@interface ProductOrderCartTableFootView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *orderTotalPrice;
@property (nonatomic, copy) DownOrderButtonClick downOrderButtonClick;

@end
