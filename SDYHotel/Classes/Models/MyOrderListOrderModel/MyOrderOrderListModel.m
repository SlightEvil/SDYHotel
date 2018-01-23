//
//  MyOrderOrderListModel.m
//  SDYHotel
//
//  Created by admin on 2017/12/21.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "MyOrderOrderListModel.h"


@implementation MyOrderOrderListModel

- (void)setDetails:(NSMutableArray *)details
{
    NSMutableArray *array = [NSMutableArray array];
    [details enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyOrderOrderDetailModel *detailModel = [MyOrderOrderDetailModel cz_objWithDict:obj];
        [array addObject:detailModel];
    }];
    _details = array.copy;
}

- (void)setPost_details:(NSMutableArray *)post_details
{
    if (post_details && post_details.count >0) {
        NSMutableArray *array = [NSMutableArray array];
        [post_details enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyOrderOrderDetailModel *detailModel = [MyOrderOrderDetailModel cz_objWithDict:obj];
            [array addObject:detailModel];
        }];
        _post_details = array.copy;
    } else {
        _post_details = [NSMutableArray array];
    }
}

@end


@implementation MyOrderOrderDetailModel

@end
