//
//  TabbarViewConModel.h
//  SDYHotel
//
//  Created by admin on 2017/12/11.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TabbarViewConModel : NSObject

@property (nonatomic) NSString *title;

@property (nonatomic) NSString *imageName;

@property (nonatomic) NSString *selectImageName;

@property (nonatomic) NSString *classString;

+ (instancetype)classWithDic:(NSDictionary *)dic;


@end
