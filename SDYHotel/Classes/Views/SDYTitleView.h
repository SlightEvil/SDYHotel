//
//  SDYTitleView.h
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>


FOUNDATION_EXPORT NSString *const titleKey;
FOUNDATION_EXPORT NSString *const accountKey;
FOUNDATION_EXPORT NSString *const balanceKey;

@interface SDYTitleView : UIView

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 账户
 */
@property (nonatomic, copy) NSString *account;

/**
 余额
 */
@property (nonatomic, copy) NSString *balance;

/**
 通告 公告
 */
@property (nonatomic, copy) NSString *notice;


/**
 必须在设置完title account balance 再调用
 */
- (void)layoutUI;



@end
