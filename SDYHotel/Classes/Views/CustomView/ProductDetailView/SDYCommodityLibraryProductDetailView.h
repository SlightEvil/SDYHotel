//
//  SDYCommodityLibraryProductDetailView.h
//  SDYHotel
//
//  Created by admin on 2018/1/2.
//  Copyright © 2018年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductDetailModel;
@class ProductShopCartModel;

@protocol SDYCommodityLibraryProductDetailViewDelegate <NSObject>

/** 详情里面确认  */
- (void)productDetailViewCompleteBtnClickHidenWhiteContentView:(ProductShopCartModel *)shopCartModel;

/** 收藏button 删除收藏  参数 用户id uid   产品id product_id */
- (void)productDetailViewRecordProductBtnClickProductID:(NSString *)productID isRecord:(BOOL)isRecord;



@end


@interface SDYCommodityLibraryProductDetailView : UIView

@property (nonatomic, assign) BOOL isCancelRecord;
@property (nonatomic) ProductDetailModel *productDetailModel;
@property (nonatomic, weak) id<SDYCommodityLibraryProductDetailViewDelegate>delegete;



- (void)showView;
- (void)hideView;


@end
