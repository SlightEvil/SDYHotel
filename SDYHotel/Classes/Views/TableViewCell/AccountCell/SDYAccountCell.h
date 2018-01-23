//
//  SDYAccountCell.h
//  SDYHotel
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountLogModel;

@interface SDYAccountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;


@property (nonatomic) AccountLogModel *accountLogModel;


@end
