//
//  ProductDetailView.h
//  SDYHotel
//
//  Created by admin on 2017/12/15.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductDetailModel;
@class ProductShopCartModel;

@protocol ProductDetailViewDelegate  <NSObject>

- (void)productDetailViewCompleteBtnClickHidenWhiteContentView:(ProductShopCartModel *)shopCartModel;


@end


@interface ProductDetailView : UIButton

@property (nonatomic) ProductDetailModel *detailModel;

@property (nonatomic, weak) id <ProductDetailViewDelegate>delegate;

//清理数据
- (void)clearData;

@end
