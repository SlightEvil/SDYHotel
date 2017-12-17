//
//  ProductDetailView.h
//  SDYHotel
//
//  Created by admin on 2017/12/15.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductDetailModel;

@protocol ProductDetailViewDelegate  <NSObject>

- (void)productDetailViewCompleteBtnClickHidenWhiteContentView;


@end


@interface ProductDetailView : UIButton

@property (nonatomic) ProductDetailModel *detailModel;

@property (nonatomic, weak) id <ProductDetailViewDelegate>delegate;


@end
