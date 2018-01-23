//
//  AccountMoneyModel.h
//  SDYHotel
//
//  Created by admin on 2018/1/4.
//  Copyright © 2018年 SanDaoYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Category.h"

//static NSString *const AccountKey =
FOUNDATION_EXPORT NSString *const AccountKey;


@interface AccountMoneyModel : NSObject

/** 账户基本信息 */
@property (nonatomic) NSDictionary *account;
/** 账户明细 */
@property (nonatomic) NSArray *account_logs;

@end



@interface AccountModel : NSObject

/** 账户id */
@property (nonatomic) NSString *account_id;
/** 登录用户id */
@property (nonatomic) NSString *user_id;
/** 账户余额 */
@property (nonatomic) NSString *balance;
/** 账户可用余额 */
@property (nonatomic) NSString *valid_balance;
/** 账户冻结余额 */
@property (nonatomic) NSString *frozen_fund;
/** 账户可提现余额 */
@property (nonatomic) NSString *cash_fund;
/** 创建时间 */
@property (nonatomic) NSString *created_at;
/** 更新时间 */
@property (nonatomic) NSString *updated_at;

@end


@interface AccountLogModel : NSObject

/**  */
@property (nonatomic) NSString *log_id;
/** 明细所属账户id */
@property (nonatomic) NSString *account_id;
/** 此明细发生的金额 */
@property (nonatomic) NSString *fund;
/** 明细标题 */
@property (nonatomic) NSString *log_title;
/** 明细备注 */
@property (nonatomic) NSString *content;
/** 此次交易后余额 */
@property (nonatomic) NSString *post_balance;
/** 交易订单号 */
@property (nonatomic) NSString *trade_no;
/** 交易类型   0消费  1充值  2提现  3 管理员调账 */
@property (nonatomic) NSString *change_type;
/** 此次交易操作主体id */
@property (nonatomic) NSString *manage_id;
/** 状态  无用 */
@property (nonatomic) NSString *status;
/** 创建时间 */
@property (nonatomic) NSString *created_at;

@end
