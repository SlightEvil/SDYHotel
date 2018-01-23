//
//  SDYTitleView.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYTitleView.h"
#import "UILabel+Category.h"
#import "Masonry.h"


NSString *const titleKey = @"titleKey";
NSString *const accountKey = @"accountKey";
NSString *const balanceKey = @"balanceKey";


@interface SDYTitleView ()

@property (nonatomic) UILabel *titleLabel;

@property (nonatomic) UILabel *accountLabel;

@property (nonatomic) UILabel *balanceLabel;

@property (nonatomic) UIScrollView *noticeScrollView;
@property (nonatomic) UILabel *noticeLabel;
@property (nonatomic) UILabel *noticeLabelCopy;

@property (nonatomic) NSTimer *timer;

@end

@implementation SDYTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kSDYTitleViewColor;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.accountLabel];
        [self addSubview:self.balanceLabel];
        [self addSubview:self.noticeScrollView];
        
        [self layoutUI];
//        inputAccessoryView
    }
    return self;
}

#pragma mark - Private method

- (void)layoutUI
{
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.balanceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-5);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.accountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.balanceLabel.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.noticeScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20);
        make.height.equalTo(self);
        make.right.equalTo(self.titleLabel.mas_left).mas_offset(-20);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

#pragma mark - Setter and Getter

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
    [self.titleLabel sizeToFit];
}

- (void)setAccount:(NSString *)account
{
    _account = account;
    self.accountLabel.text = _account;
    [self.accountLabel sizeToFit];
}

- (void)setBalance:(NSString *)balance
{
    _balance = balance;
    self.balanceLabel.text = [NSString stringWithFormat:@"余额 ¥%@",_balance];
    [self.balanceLabel sizeToFit];
}

- (void)setNotice:(NSString *)notice
{
    _notice = notice;
    
    [self.timer setFireDate:[NSDate distantFuture]];
    self.noticeScrollView.contentOffset = CGPointZero;
    
    self.noticeLabelCopy.text = self.noticeLabel.text = [NSString stringWithFormat:@"公告: %@",_notice];
    [self.noticeLabelCopy sizeToFit];
    [self.noticeLabel sizeToFit];
    
    CGSize  size = self.noticeLabel.bounds.size;
    self.noticeScrollView.contentSize = CGSizeMake(size.width*2, 0);
    
    [self.noticeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.noticeScrollView);
        make.left.equalTo(self.noticeScrollView).mas_offset(20);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
    [self.noticeLabelCopy mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.noticeLabel);
        make.left.mas_equalTo(self.noticeLabel.mas_right).mas_offset(20);
    }];

//    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
//        self.noticeLabel.transform = CGAffineTransformMakeTranslation(-size.width*2 , 0);
//        self.noticeLabelCopy.transform = CGAffineTransformMakeTranslation(-size.width*2, 0);
//
//    } completion:nil];
    
    [self.timer setFireDate:[NSDate distantPast]];

}

#pragma mark - private method

- (void)timeScrollViewScroll
{
//    [UIView animateWithDuration:2.9 animations:^{
//        self.noticeScrollView.contentOffset = CGPointMake(self.noticeScrollView.contentOffset.x + self.noticeScrollView.bounds.size.width/5, self.noticeScrollView.contentOffset.y);
//    }];
    
    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.noticeScrollView.contentOffset = CGPointMake(self.noticeScrollView.contentOffset.x + self.noticeScrollView.bounds.size.width, self.noticeScrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        if (self.noticeScrollView.contentOffset.x >= self.noticeScrollView.contentSize.width) {
            self.noticeScrollView.contentOffset = CGPointZero;
        }
    }];

}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timeScrollViewScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:[UIColor blackColor] font:20];
    }
    return _titleLabel;
}

- (UILabel *)accountLabel
{
    if (!_accountLabel) {
        _accountLabel = [UILabel labelWithTextColor:[UIColor blackColor] font:18];
    }
    return _accountLabel;
}

- (UILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [UILabel labelWithTextColor:[UIColor blackColor] font:18];
    }
    return _balanceLabel;
}

- (UIScrollView *)noticeScrollView
{
    if (!_noticeScrollView) {
        _noticeScrollView = [[UIScrollView alloc]init];
        [_noticeScrollView addSubview:self.noticeLabel];
        [_noticeScrollView addSubview:self.noticeLabelCopy];
    }
    return _noticeScrollView;
}

- (UILabel *)noticeLabel
{
    if (!_noticeLabel) {
        _noticeLabel = [UILabel labelWithTextColor:[UIColor blackColor] font:18];
        
    }
    return _noticeLabel;
}

- (UILabel *)noticeLabelCopy
{
    if (!_noticeLabelCopy) {
        _noticeLabelCopy = [UILabel labelWithTextColor:[UIColor blackColor] font:18];
    }
    return _noticeLabelCopy;
}


@end
