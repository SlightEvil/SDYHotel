//
//  ProductDetailView.h
//  SDYHotel
//
//  Created by admin on 2017/12/15.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductDetailModel;


@interface ProductDetailView : UIButton

@property (nonatomic) ProductDetailModel *detailModel;



- (void)showView;

- (void)hideView;


@end
