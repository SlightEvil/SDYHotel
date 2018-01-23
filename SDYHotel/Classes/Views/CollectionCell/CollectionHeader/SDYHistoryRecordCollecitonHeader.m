//
//  SDYHistoryRecordCollecitonHeader.m
//  SDYHotel
//
//  Created by admin on 2017/12/27.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYHistoryRecordCollecitonHeader.h"
#import "UIImage+Category.h"

@interface SDYHistoryRecordCollecitonHeader ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *clearHistoryBtn;


@end

@implementation SDYHistoryRecordCollecitonHeader
{
    CGFloat _width;
    CGFloat _height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _width = self.bounds.size.width;
        _height = self.bounds.size.height;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.clearHistoryBtn];
    }
    return self;
}

- (void)clearBtnClick
{
    if (self.clearHistoryRecordBtnClick) {
        self.clearHistoryRecordBtnClick();
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"最近搜索";
        [_titleLabel sizeToFit];
        _titleLabel.frame = CGRectMake(20, 10, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    }
    return _titleLabel;
}

- (UIButton *)clearHistoryBtn
{
    if (!_clearHistoryBtn) {
        _clearHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearHistoryBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_clearHistoryBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [_clearHistoryBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_clearHistoryBtn setImage:[UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_delete"] sizs:CGSizeMake(25, 25)] forState:UIControlStateNormal];
        [_clearHistoryBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _clearHistoryBtn.frame = CGRectMake(_width-160, 0, 150, 40);
        
    }
    return _clearHistoryBtn;
}


@end
