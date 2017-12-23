//
//  ProductCollectionCell.h
//  SDYHotel
//
//  Created by admin on 2017/12/23.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModle;

@interface ProductCollectionCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *productPrice;

@property (weak, nonatomic) IBOutlet UILabel *stock;


@property (nonatomic) ProductModle *productModel;

@end
