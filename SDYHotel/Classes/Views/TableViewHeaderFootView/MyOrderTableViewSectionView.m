//
//  MyOrderTableViewSectionView.m
//  SDYHotel
//
//  Created by admin on 2017/12/21.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "MyOrderTableViewSectionView.h"
#import "MyOrderOrderListModel.h"
#import "Masonry.h"

@interface MyOrderTableViewSectionView ()

/**
 section 的点击背景button
 */
@property (nonatomic) UIButton *sectionBgBtn;

/**
 section的title
 */
@property (nonatomic) UILabel *sectionTitleLabel;

@end

@implementation MyOrderTableViewSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
         CGFloat width = (kScreenWidth - 200)/2;
        
        [self.contentView addSubview:self.sectionBgBtn];
        [self.contentView addSubview:self.sectionTitleLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor grayColor];
        lineView.frame = CGRectMake(0, 49-1, width, 1);
        [self.contentView addSubview:lineView];
        
        
        self.sectionBgBtn.frame = CGRectMake(0, 0, width, 49);
        self.sectionTitleLabel.frame = CGRectMake(0, 0, width, 48);
        
        
//        [self.sectionBgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.bottom.equalTo(self.contentView);
//        }];
//        [self.sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.equalTo(self.contentView);
//            make.bottom.equalTo(self.contentView).mas_offset(-1);
//        }];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self.contentView);
//            make.height.mas_equalTo(1);
//        }];
    }
    return self;
}


- (void)sectionBgBtnClick
{
    self.sectionModel.isExpanded = !self.sectionModel.isExpanded;
    
    if (self.sectionClickBlock) {
        self.sectionClickBlock(YES);
    }
}


#pragma mark - Getter and Setter

- (void)setSectionModel:(MyOrderOrderListModel *)sectionModel
{
    _sectionModel = sectionModel;
    self.sectionTitleLabel.text = _sectionModel.shop_name;
}


- (UIButton *)sectionBgBtn
{
    if (!_sectionBgBtn) {
        _sectionBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sectionBgBtn.backgroundColor = [UIColor clearColor];
        [_sectionBgBtn addTarget:self action:@selector(sectionBgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sectionBgBtn;
}

- (UILabel *)sectionTitleLabel
{
    if (!_sectionTitleLabel) {
        _sectionTitleLabel = [[UILabel alloc] init];
        _sectionTitleLabel.textColor = [UIColor blackColor];
    }
    return _sectionTitleLabel;
}


@end
