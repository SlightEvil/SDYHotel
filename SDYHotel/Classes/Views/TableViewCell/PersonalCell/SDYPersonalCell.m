//
//  SDYPersonalCell.m
//  SDYHotel
//
//  Created by admin on 2017/12/29.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYPersonalCell.h"

@implementation SDYPersonalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)noLookButton:(id)sender {
    if (self.buttonClick) {
        self.buttonClick(OrderStateNoLook);
    }
}
- (IBAction)noSloveButton:(id)sender {
    if (self.buttonClick) {
        self.buttonClick(OrderStateNoSlove);
    }
}
- (IBAction)slovedButton:(id)sender {
    if (self.buttonClick) {
        self.buttonClick(OrderStateSolved);
    }
}
- (IBAction)allOrderButton:(id)sender {
    if (self.buttonClick) {
        self.buttonClick(OrderStateAll);
    }
}
@end
