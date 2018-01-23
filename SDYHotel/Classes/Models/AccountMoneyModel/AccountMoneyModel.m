//
//  AccountMoneyModel.m
//  SDYHotel
//
//  Created by admin on 2018/1/4.
//  Copyright © 2018年 SanDaoYi. All rights reserved.
//

#import "AccountMoneyModel.h"

NSString *const AccountKey = @"AccountMoneyModelAccountKey";

@implementation AccountMoneyModel

- (void)setAccount:(NSDictionary *)account
{
    AccountModel *accountModel = [AccountModel cz_objWithDict:account];
    _account = [NSDictionary dictionaryWithObject:accountModel forKey:AccountKey];
}

- (void)setAccount_logs:(NSArray *)account_logs
{
    NSMutableArray *array = [NSMutableArray array];
    [account_logs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AccountLogModel *logModel = [AccountLogModel cz_objWithDict:obj];
        [array addObject:logModel];
    }];
    _account_logs = array;
}


@end

@implementation  AccountModel

@end

@implementation AccountLogModel

@end
