//
//  ProdectLibraryOrderCell.h
//  SDYHotel
//
//  Created by admin on 2017/12/17.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductShopCartModel;

@interface ProductLibraryOrderCell : UITableViewCell

@property (nonatomic) ProductShopCartModel *shopCartModel;

- (void)cellDeleteBtnClick:(void(^)(void))deleteBlock;



@end
