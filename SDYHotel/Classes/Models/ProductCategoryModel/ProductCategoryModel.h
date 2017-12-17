//
//  ProductCategoryModel.h
//  SDYHotel
//
//  Created by admin on 2017/12/14.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Category.h"


/**
 产品分类model  sectionmodel 跟cellModle 的属性都是一样的，section 比cell 多一个存放cellmodel的数组
 */
@interface ProductCategoryModel : NSObject

@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *category_name;
@property (nonatomic, copy) NSString *category_logo;

//@property (nonatomic, assign) BOOL isExpanded;


/**
 传入一个data数组，返回model数组（section跟cell 模型数据一样）
 */
@property (nonatomic) NSMutableArray *children;


@end
