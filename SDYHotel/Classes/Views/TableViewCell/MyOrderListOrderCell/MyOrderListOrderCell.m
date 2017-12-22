//
//  MyOrderListOrderCell.m
//  SDYHotel
//
//  Created by admin on 2017/12/22.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "MyOrderListOrderCell.h"
#import "MyOrderOrderListModel.h"

@interface MyOrderListOrderCell ()

//@property (nonatomic) UILabel *productNameLabel;
//
//@property (nonatomic) UILabel *numberUnitLabel;
//
//@property (nonatomic) UILabel *totalPriceLabel;
//


@end

@implementation MyOrderListOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        [self.contentView addSubview:self.productNameLabel];
//        [self.contentView addSubview:self.numberUnitLabel];
//        [self.contentView addSubview:self.totalPriceLabel];
//
//
//    }
//    return self;
//}



- (void)setOrderDetailModel:(MyOrderOrderDetailModel *)orderDetailModel
{
    _orderDetailModel = orderDetailModel;
    
    self.productNameLabel.text = _orderDetailModel.product_name;
    self.numberUnitLabel.text = [NSString stringWithFormat:@"%@ * %@",_orderDetailModel.price,_orderDetailModel.quantity];
    self.totalPriceLabel.text = _orderDetailModel.total_price;
    
}







@end
