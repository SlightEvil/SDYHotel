//
//  SDYHistoryRecordCollecitonHeader.h
//  SDYHotel
//
//  Created by admin on 2017/12/27.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClearHistoryRecordBtnClick)(void);

@interface SDYHistoryRecordCollecitonHeader : UICollectionReusableView

@property (nonatomic, copy) ClearHistoryRecordBtnClick clearHistoryRecordBtnClick;


@end
