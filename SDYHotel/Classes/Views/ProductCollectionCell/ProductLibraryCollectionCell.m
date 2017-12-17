//
//  ProductLibraryCollectionCell.m
//  SDYHotel
//
//  Created by admin on 2017/12/14.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ProductLibraryCollectionCell.h"

@implementation ProductLibraryCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.font = [UIFont systemFontOfSize:18];
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.backgroundColor = kUIColorFromRGB(0xf0f0f0);
    // Initialization code
}


@end
