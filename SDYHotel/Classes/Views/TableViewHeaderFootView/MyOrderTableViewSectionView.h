//
//  MyOrderTableViewSectionView.h
//  SDYHotel
//
//  Created by admin on 2017/12/21.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderOrderListModel;

typedef void(^SectionClickBlock)(BOOL isExpanded);

@interface MyOrderTableViewSectionView : UITableViewHeaderFooterView

/**
 点击section
 */
@property (nonatomic, copy) SectionClickBlock sectionClickBlock;


/**
 sectionModel  MyOrderOrderListModel
 */
@property (nonatomic) MyOrderOrderListModel *sectionModel;

@end
