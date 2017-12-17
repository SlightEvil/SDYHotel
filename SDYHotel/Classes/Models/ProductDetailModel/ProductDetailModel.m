//
//  ProductDetailModel.m
//  SDYHotel
//
//  Created by admin on 2017/12/14.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ProductDetailModel.h"


NSString *const ProductDetailProductKey = @"ProductDetailProductKey";

@implementation ProductDetailModel

- (void)setAttributes:(NSMutableArray *)attributes
{
    
    NSMutableArray *array = [NSMutableArray array];
    
    [attributes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ProductDetailAttributesModel *model = [ProductDetailAttributesModel cz_objWithDict:obj];
        [array addObject:model];
    }];
    _attributes = array.copy;
}

- (void)setShops:(NSMutableArray *)shops
{
    NSMutableArray *array = [NSMutableArray array];
    [shops enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ProductDetailShopModel *model = [ProductDetailShopModel cz_objWithDict:obj];
        [array addObject:model];
    }];
    _shops = array.copy;
}

- (void)setSkus:(NSMutableArray *)skus
{
    NSMutableArray *array = [NSMutableArray array];
    [skus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ProductDetailSkusModel *model = [ProductDetailSkusModel cz_objWithDict:obj];
        [array addObject:model];
    }];
    _skus = array.copy;
}

- (void)setProduct:(NSMutableDictionary *)product
{
    _product = [NSMutableDictionary dictionary];
    ProductDetailProductModel *model = [ProductDetailProductModel cz_objWithDict:product];
    [_product setObject:model forKey:ProductDetailProductKey];
}

@end

#pragma mark - 一个.h 文件中创建多个 @interface ，需要在.m 文件中 创建多个@implementation

@implementation ProductDetailProductModel
@end

@implementation ProductDetailSkusModel
@end

@implementation ProductDetailShopModel
@end

@implementation ProductDetailAttributesModel
@end



