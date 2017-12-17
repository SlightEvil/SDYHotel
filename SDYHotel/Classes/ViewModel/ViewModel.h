//
//  ViewModel.h
//  SDYHotel
//
//  Created by admin on 2017/12/14.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductModle;
@class ProductCategoryModel;


@interface ViewModel : NSObject

/**
 产品分类 数组
 */
@property (nonatomic) NSMutableArray <ProductCategoryModel *>*productCategorysAry;


/**
 产品数组
 */
@property (nonatomic) NSMutableArray <ProductModle *>*productsAry;


@end
