//
//  UITextField+Category.h
//  SDYHotel
//
//  Created by admin on 2018/1/2.
//  Copyright © 2018年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Category)

/**
 设置 textfield inputaccessoryView 完成 按钮 来取消焦点 title为提示信息
 */
- (void)setupAccessoryViewWithDone:(NSString *)title;


@end
