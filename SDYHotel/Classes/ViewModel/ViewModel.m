//
//  ViewModel.m
//  SDYHotel
//
//  Created by admin on 2017/12/14.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ViewModel.h"
#import "ProductModle.h"
#import "ProductCategoryModel.h"



@implementation ViewModel


- (NSMutableArray<ProductCategoryModel *> *)productCategorysAry
{
    if (!_productCategorysAry) {
        _productCategorysAry = [NSMutableArray array];
    }
    return _productCategorysAry;
}

- (NSMutableArray<ProductModle *> *)productsAry
{
    if (!_productsAry) {
        _productsAry = [NSMutableArray array];
    }
    return _productsAry;
}

@end
