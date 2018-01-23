//
//  PersonalFooterView.h
//  SDYHotel
//
//  Created by admin on 2017/12/29.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalFooterView : UITableViewHeaderFooterView

@property (nonatomic, copy) void(^buttonClick)(void);

@end
