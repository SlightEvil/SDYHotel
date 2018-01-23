//
//  SDYProductDetailAttrivuteCell.h
//  SDYHotel
//
//  Created by admin on 2017/12/30.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductDetailSkusModel;


@interface SDYProductDetailAttrivuteCell : UITableViewCell


//@property (nonatomic) ProductDetailSkusModel *model;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) BOOL buttonIsSelected;
@property (nonatomic, copy) void(^attributeBtnClick)(NSUInteger index);

/** 必须在其他属性前设置 */
@property (nonatomic, copy) NSString *productUnit;
/** 规格 */
@property (nonatomic, copy) NSString *attribute;
/** 商场价格 */
@property (nonatomic, copy) NSString *mallPrice;
/** 市场价格 */
@property (nonatomic, copy) NSString *makePrice;




@end
