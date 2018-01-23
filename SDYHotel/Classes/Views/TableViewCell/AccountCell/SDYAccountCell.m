//
//  SDYAccountCell.m
//  SDYHotel
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 SanDaoYi. All rights reserved.
//

#import "SDYAccountCell.h"
#import "AccountMoneyModel.h"


@implementation SDYAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (void)setAccountLogModel:(AccountLogModel *)accountLogModel
{
    _accountLogModel = accountLogModel;
    self.typeLabel.text = _accountLogModel.log_title;
    self.orderNoLabel.text = _accountLogModel.trade_no;
    self.timeLabel.text = _accountLogModel.created_at;
    self.moneyLabel.text = _accountLogModel.fund;
    self.balanceLabel.text = _accountLogModel.post_balance;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
