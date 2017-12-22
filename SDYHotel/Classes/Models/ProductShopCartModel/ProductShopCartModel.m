//
//  ProductShopCartModel.m
//  SDYHotel
//
//  Created by admin on 2017/12/19.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ProductShopCartModel.h"


@implementation ProductShopCartDetailModel

@end


@implementation ProductOrderModel

- (NSMutableArray *)details
{
    if (!_details) {
        _details = [NSMutableArray array];
    }
    return _details;
}

@end

@implementation ProductOrderDetailModel

@end


@implementation ProductShopCartModel



- (NSString *)toalPrice
{
    return [NSString stringWithFormat:@"%.2f",self.number * self.unitPrice];
 
}


@end
