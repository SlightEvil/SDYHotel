//
//  ProductCategoryModel.m
//  SDYHotel
//
//  Created by admin on 2017/12/14.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ProductCategoryModel.h"

@implementation ProductCategoryModel

- (void)setChildren:(NSMutableArray *)children
{
    NSMutableArray *ary = [NSMutableArray array];
    [children enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        ProductCategoryModel *cellModel = [ProductCategoryModel cz_objWithDict:obj];
        [ary  addObject:cellModel];
    }];
    
    _children = ary.copy;
}

@end
