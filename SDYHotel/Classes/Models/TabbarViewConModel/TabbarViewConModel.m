//
//  TabbarViewConModel.m
//  SDYHotel
//
//  Created by admin on 2017/12/11.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "TabbarViewConModel.h"

@implementation TabbarViewConModel

+ (instancetype)classWithDic:(NSDictionary *)dic
{
    TabbarViewConModel *viewModel = [super new];
    
    [viewModel setValuesForKeysWithDictionary:dic];
    
    return viewModel;
}

@end
