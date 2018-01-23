//
//  SDYHistoryRecordCell.m
//  SDYHotel
//
//  Created by admin on 2017/12/27.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYHistoryRecordCell.h"

@implementation SDYHistoryRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.layer.borderWidth = 0.5;
    self.title.layer.borderColor = [[UIColor blackColor] CGColor];
    self.title.font = [UIFont systemFontOfSize:kCellFont];
    

    
    self.selectedBackgroundView = [self cellSelectView];
    
}

- (UIView *)cellSelectView
{
    UIView *view = [[UIView alloc] initWithFrame:self.contentView.bounds];
    view.backgroundColor = kSDYColorGreen;
    return view;
}





@end
