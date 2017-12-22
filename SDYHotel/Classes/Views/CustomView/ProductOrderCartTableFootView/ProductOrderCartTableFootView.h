//
//  ProductOrderCartTableFootView.h
//  SDYHotel
//
//  Created by admin on 2017/12/20.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductOrderCartTableFootViewDelegate <NSObject>

- (void)placeOrderClickWithRemarkStr:(NSString *)remarkStr;

@end


@interface ProductOrderCartTableFootView : UIView

@property (nonatomic, weak) id <ProductOrderCartTableFootViewDelegate>delegate;


@end
