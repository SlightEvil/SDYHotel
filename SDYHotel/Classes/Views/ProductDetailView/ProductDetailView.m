//
//  ProductDetailView.m
//  SDYHotel
//
//  Created by admin on 2017/12/15.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ProductDetailView.h"
#import "UIButton+Category.h"
#import "UILabel+Category.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProductDetailModel.h"
#import "Function.h"

static NSString *const ProductDetailViewCellIdentifier = @"ProductDetailViewCellIdentifier";


@interface ProductDetailView ()<UITableViewDelegate,UITableViewDataSource>

//商品
@property (nonatomic) UIImageView *iconImage;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *shopNameLabel;
@property (nonatomic) UITextView *detailTextView;

//数量
@property (nonatomic) UIButton *addNumberBtn;
@property (nonatomic) UIButton *reduceNumberBtn;
@property (nonatomic) UITextField *numberTextField;
//商家
@property (nonatomic) UITableView *shopTableView;
//确定
@property (nonatomic) UIButton *comppleteBtn;

@property (nonatomic) ProductDetailProductModel *productModel;

@property (nonatomic) NSMutableArray *array;


@end

@implementation ProductDetailView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kUIColorFromRGB(0xf0f0f0);
        [self addSubview:self.iconImage];
        [self addSubview:self.comppleteBtn];
        [self addSubview:self.nameLabel];
        [self addSubview:self.shopNameLabel];
        [self addSubview:self.detailTextView];
        [self addSubview:self.reduceNumberBtn];
        [self addSubview:self.numberTextField];
        [self addSubview:self.addNumberBtn];
        [self addSubview:self.shopTableView];
        
        [self layoutWithAuto];
    }
    return self;
}

#pragma mark - Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailModel.shops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProductDetailViewCellIdentifier forIndexPath:indexPath];
    ProductDetailShopModel *shopModel = self.detailModel.shops[indexPath.row];
    cell.textLabel.text = shopModel.shop_name;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

#pragma mark - event response

- (void)reduceNumberBtnClick
{
    NSInteger number= [self.numberTextField.text integerValue];
    if (number >= 1) {
        number -= 1;
        self.numberTextField.text  = [NSString stringWithFormat:@"%ld",number];
    }
}

- (void)addNumberBtnClick
{
    NSInteger number = [self.numberTextField.text integerValue];

    if (number < [self.productModel.stock integerValue]) {
        number += 1;
        self.numberTextField.text = [NSString stringWithFormat:@"%ld",number];
    }
}

/**
 点击确定安按钮动作
 */
- (void)completeBtnClick
{
    if ([self.delegate respondsToSelector:@selector(productDetailViewCompleteBtnClickHidenWhiteContentView)]) {
        [self.delegate productDetailViewCompleteBtnClickHidenWhiteContentView];
    }
}

- (void)gradeAndUnitBtnClick:(UIButton *)sender
{
    NSLog(@"点击");
}

#pragma mark - private method

- (void)layoutWithAuto
{
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).mas_offset(20);
        make.width.height.mas_equalTo(100);
    }];
    [self.shopTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-20);
        make.top.equalTo(self.iconImage);
        make.width.mas_equalTo(200);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-150);
    }];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImage);
        make.left.equalTo(self.iconImage.mas_right).mas_offset(20);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.shopTableView.mas_left).mas_offset(-100);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).mas_offset(20);
        make.right.equalTo(self.shopTableView.mas_left).mas_offset(-100);
        make.bottom.equalTo(self.shopNameLabel.mas_top).mas_offset(-10);
        make.height.mas_equalTo(40);
    }];
    [self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_bottom).mas_offset(20);
        make.left.equalTo(self.iconImage);
        make.right.equalTo(self.shopTableView.mas_left).mas_offset(-100);
        make.height.mas_equalTo(80);
    }];
    [self.addNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailTextView.mas_bottom).mas_offset(20);
        make.right.equalTo(self.shopTableView.mas_left).mas_offset(-100);
        make.width.height.mas_equalTo(40);
    }];
    [self.numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.addNumberBtn);
        make.right.equalTo(self.addNumberBtn.mas_left);
        make.width.mas_equalTo(80);
    }];
    [self.reduceNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.addNumberBtn);
        make.right.equalTo(self.numberTextField.mas_left);
    }];
    [self.comppleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).mas_offset(-90);
        make.right.equalTo(self.shopTableView.mas_left).mas_offset(-100);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(100);
    }];
}

//设置级别 （1，2，3级） 设置数量：（整条，整件，单价）
- (void)makeGradeBtnWithAttributesArray:(NSMutableArray *)array
{
    __weak typeof(self)WeakSelf = self;
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        __strong typeof(WeakSelf)strongSelf = WeakSelf;
        
        ProductDetailAttributesModel *attributesModel = obj;
        
        UILabel *label = [UILabel labelWithTextColor:nil font:18];
        label.text = attributesModel.group_name;
        label.tag = buttonTagCommodityLibraryProductDetailViewGrade + 10*idx;
        [strongSelf addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.detailTextView);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(60);
            make.top.equalTo(self.detailTextView.mas_bottom).mas_offset(10+(10+40)*idx);
        }];
        
        [attributesModel.attributes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            NSString *title = dic[@"attribute_name"];
         
            UIButton *btn = [UIButton btnWithTitle:title font:18 textColor:nil bgColor:[UIColor whiteColor]];
            btn.tag = label.tag + 1 +idx;
            [btn addTarget:self action:@selector(gradeAndUnitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [strongSelf addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label);
                make.left.equalTo(label.mas_right).mas_offset(10+(10+60)*idx);
                make.height.width.equalTo(label);
            }];
        }];
    }];
}

- (UIButton *)btnWithTitleWithTag:(NSInteger)tag title:(NSString *)title
{
    UIButton *btn = [UIButton btnWithTitle:title font:18 textColor:nil bgColor:[UIColor whiteColor]];
    btn.tag = tag;
    return btn;
}

#pragma mark - getter and setter

- (void)setDetailModel:(ProductDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    self.productModel = detailModel.product[ProductDetailProductKey];
    self.nameLabel.text = self.productModel.product_name;
    self.detailTextView.text = self.productModel.product_description;
    self.shopNameLabel.text = self.productModel.shop_name;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:kSDYImageUrl(self.productModel.thumbnail)]];
    
    [self makeGradeBtnWithAttributesArray:_detailModel.attributes];
    
    [self.shopTableView reloadData];
}



- (UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.layer.borderWidth = 1;
        _iconImage.layer.borderColor = [[UIColor blackColor] CGColor];
//        [_iconImage sd_setImageWithURL:[NSURL URLWithString:@"http://pic23.photophoto.cn/20120530/0020033092420808_b.jpg"]];
    }
    return _iconImage;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithTextColor:nil font:18];
        _nameLabel.backgroundColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)shopNameLabel
{
    if (!_shopNameLabel) {
        _shopNameLabel = [UILabel labelWithTextColor:nil font:18];
        _shopNameLabel.backgroundColor = [UIColor whiteColor];
    }
    return _shopNameLabel;
}

- (UITextView *)detailTextView
{
    if (!_detailTextView) {
        _detailTextView = [[UITextView alloc] init];
        _detailTextView.font = [UIFont systemFontOfSize:17];
        _detailTextView.textColor = kUIColorFromRGB(0x999999);
        _detailTextView.selectable = NO;
        _detailTextView.editable = NO;
    }
    return _detailTextView;
}




- (UIButton *)reduceNumberBtn
{
    if (!_reduceNumberBtn) {
        _reduceNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reduceNumberBtn setImage:[UIImage imageNamed:@"icon_subtract"] forState:UIControlStateNormal];
        [_reduceNumberBtn addTarget:self action:@selector(reduceNumberBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _reduceNumberBtn.layer.borderWidth = 0.5;
        _reduceNumberBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    }
    return _reduceNumberBtn;
}

- (UIButton *)addNumberBtn
{
    if (!_addNumberBtn) {
        _addNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addNumberBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        [_addNumberBtn addTarget:self action:@selector(addNumberBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _addNumberBtn.layer.borderWidth = 0.5;
        _addNumberBtn.layer.borderColor = [[UIColor blackColor] CGColor];
        
    }
    return _addNumberBtn;
}

- (UITextField *)numberTextField
{
    if (!_numberTextField) {
        _numberTextField = [[UITextField alloc] init];
        _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _numberTextField.font = [UIFont systemFontOfSize:18];
        _numberTextField.borderStyle = UITextBorderStyleRoundedRect;
        _numberTextField.textAlignment = NSTextAlignmentCenter;
        _numberTextField.backgroundColor = [UIColor whiteColor];
        _numberTextField.borderStyle = UITextBorderStyleBezel;
        _numberTextField.enabled = NO;
        _numberTextField.text = @"0";
        
    }
    return _numberTextField;
}

- (UIButton *)comppleteBtn
{
    if (!_comppleteBtn) {
        _comppleteBtn = [UIButton btnWithTitle:@"确定" font:18 textColor:[UIColor whiteColor] bgColor:kUIColorFromRGB(0x06ce8a)];
        [_comppleteBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comppleteBtn;
}

- (UITableView *)shopTableView
{
    if (!_shopTableView) {
        _shopTableView = [[UITableView alloc] init];
        _shopTableView.delegate = self;
        _shopTableView.dataSource = self;
        [_shopTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ProductDetailViewCellIdentifier];
        _shopTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, _shopTableView.contentSize.width, 40);
        label.text = @"供应商";
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderWidth = 1;
        label.layer.borderColor = [[UIColor blackColor] CGColor];
 
        _shopTableView.tableHeaderView = label;
    }
    return _shopTableView;
}

@end
