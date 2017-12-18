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

#import "ProductDetailViewCollectionCell.h"
#import "ProductDetailViewCollectionReusableView.h"

/**
 价格
 */
@interface PriceModel : NSObject

@property (nonatomic, assign) NSString *unit;
@property (nonatomic, assign) NSString *grade;

+ (NSString *)stringWithModel:(PriceModel *)model;//返回字符串
- (void)clearData;//重置model

@end

@implementation PriceModel

+ (NSString *)stringWithModel:(PriceModel *)model
{
    return [NSString stringWithFormat:@"%@,%@",model.unit,model.grade];
}
- (void)clearData
{
    self.unit = nil;
    self.grade = nil;
}

@end


static NSString *const ProductDetailViewCellIdentifier = @"ProductDetailViewCellIdentifier";
static NSString *const ProductDetailViewCollectionCellIdentifier = @"ProdectDetailViewCollectionCellIdentifier";
static NSString *const ProductDetailViewCollectionReusableViewIdentifier = @"ProductDetailViewCollectionReusableViewIdentifier";


static NSString *const attributesNameKey = @"attribute_name";
static NSString *const attributesIdKey = @"attribute_id";

@interface ProductDetailView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//商品
@property (nonatomic) UIImageView *iconImage;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *shopNameLabel;
@property (nonatomic) UITextView *detailTextView;
@property (nonatomic) UILabel *priceLabel;

//显示级别和单位
@property (nonatomic) UICollectionView *attributesCollectionView;

//数量
@property (nonatomic) UIButton *addNumberBtn;
@property (nonatomic) UIButton *reduceNumberBtn;
@property (nonatomic) UITextField *numberTextField;
//商家
@property (nonatomic) UITableView *shopTableView;
//确定
@property (nonatomic) UIButton *comppleteBtn;

@property (nonatomic) ProductDetailProductModel *productModel;

@property (nonatomic) NSMutableArray *gradeBtnTagArray;//
@property (nonatomic) NSMutableArray *unitBtnTagArray;//没用到暂时
@property (nonatomic) NSMutableArray *priceWithTagArray;//
@property (nonatomic) PriceModel *price;//

@property (nonatomic) NSMutableArray *productPriceArray;

@end

@implementation ProductDetailView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.price = [[PriceModel alloc] init];
        
        self.backgroundColor = kUIColorFromRGB(0xf0f0f0);
        [self addSubview:self.iconImage];
        [self addSubview:self.comppleteBtn];
        [self addSubview:self.nameLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.shopNameLabel];
        [self addSubview:self.detailTextView];
        [self addSubview:self.reduceNumberBtn];
        [self addSubview:self.numberTextField];
        [self addSubview:self.addNumberBtn];
        [self addSubview:self.shopTableView];
        [self addSubview:self.attributesCollectionView];
        
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
    if (self.detailModel.shops.count > 0) {
        ProductDetailShopModel *shopModel = self.detailModel.shops[indexPath.row];
        [self requestProductDetailWithProductName:self.productModel.product_name shopID:shopModel.shop_id];
    }
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

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     1、 section 只有1个  （只有单价）
     2、 section 有2个
     */
  //只有一个section  单价
    if (self.detailModel.skus.count == 1) {//只有单价超过2个标示有2个section
        ProductDetailSkusModel *skusModel = [self.detailModel.skus firstObject];
        self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",skusModel.mall_price];
        return;
    }
    //有2个section 级别  单位
    ProductDetailAttributesModel *attributesModel = self.detailModel.attributes[indexPath.section];
    NSDictionary *dic = attributesModel.attributes[indexPath.row];
    
    if (indexPath.section == 0) {
        self.price.grade = dic[attributesIdKey];
    }
    if (indexPath.section == 1) {
        self.price.unit = dic[attributesIdKey];
    }
    
    //如果有多个section 中的row 被选中 取消其他的选中的row
    NSArray<NSIndexPath *> *selectAry = [collectionView indexPathsForSelectedItems];
    [selectAry enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *selectIndexPath = obj;
        if (indexPath.section == 0) {// 在section=0 的时候取消其他的选中效果
            if (indexPath.row != selectIndexPath.row && selectIndexPath.section == 0) {
                [collectionView deselectItemAtIndexPath:selectIndexPath animated:NO];
            }
        }
        else if (indexPath.section == 1) {// 在section=1 的时候取消其他的选中效果
            if (indexPath.row != selectIndexPath.row && selectIndexPath.section == 1) {
                [collectionView deselectItemAtIndexPath:selectIndexPath animated:NO];
            }
        }
    }];
    
    NSString *priceID = [PriceModel stringWithModel:self.price];
    
    //根据选择2个section中的row 获取的id 判断价格
    [self.detailModel.skus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ProductDetailSkusModel *skusModel = obj;
        if ([priceID isEqualToString:skusModel.attributes]) {
            self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",skusModel.mall_price];
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.detailModel.attributes.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.detailModel) {
        ProductDetailAttributesModel *attributesModel = self.detailModel.attributes[section];
        return attributesModel.attributes.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProductDetailViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductDetailViewCollectionCellIdentifier forIndexPath:indexPath];
    UIView *selsetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
    selsetView.backgroundColor = kUIColorFromRGB(0x06ce8a);
    cell.selectedBackgroundView = selsetView;
    
    ProductDetailAttributesModel *attributesModel = self.detailModel.attributes[indexPath.section];
   NSDictionary *dic = attributesModel.attributes[indexPath.row];

    cell.titleLabel.text = dic[attributesNameKey];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        ProductDetailViewCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ProductDetailViewCollectionReusableViewIdentifier forIndexPath:indexPath];
        ProductDetailAttributesModel *attributesModel = self.detailModel.attributes[indexPath.section];
       
        reusableView.titleLabel.text = attributesModel.group_name;
        
        return reusableView;
    } else {
        UICollectionReusableView *footView = [[UICollectionReusableView alloc]init];
        footView.backgroundColor = [UIColor clearColor];
        return footView;
    }
    return nil;
}


#pragma mark - event response

//减少商品数量
- (void)reduceNumberBtnClick
{
    NSInteger number= [self.numberTextField.text integerValue];
    if (number >= 1) {
        number -= 1;
        self.numberTextField.text  = [NSString stringWithFormat:@"%ld",number];
    }
}
//添加数量
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
    [self clearData];
    if ([self.delegate respondsToSelector:@selector(productDetailViewCompleteBtnClickHidenWhiteContentView)]) {
        [self.delegate productDetailViewCompleteBtnClickHidenWhiteContentView];
    }
    
    /*
     获取 价格 ，获取number 
     
     */
    
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
        make.bottom.equalTo(self.shopNameLabel.mas_top).mas_offset(-10);
        make.height.mas_equalTo(40);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).mas_offset(10);
        make.right.equalTo(self.shopTableView.mas_left).mas_offset(-100);
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
    [self.attributesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailTextView.mas_bottom).mas_offset(20);
        make.left.equalTo(self.detailTextView);
        make.right.equalTo(self.reduceNumberBtn.mas_left).mas_offset(-100);
        make.height.mas_equalTo(200);
    }];
    [self.comppleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).mas_offset(-90);
        make.right.equalTo(self.shopTableView.mas_left).mas_offset(-100);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(100);
    }];
}

/**
设置除了指定btn tag 的button的select 为NO

 @param tagAry 级别 还是 单位 tagAry
 @param tag 指定的tag
 */
- (void)btnRemoveSelectWithTagAry:(NSArray *)tagAry exceptTag:(NSInteger)tag
{
    [tagAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj integerValue] != tag) {
            UIButton *btn = [self viewWithTag:[obj integerValue]];
            btn.selected = NO;
            btn.backgroundColor = [UIColor whiteColor];
        }
    }];
}

/**
 对数组进行升序排列

 @param array 需要排序的数组
 @return 升序后的数组
 */
- (NSArray *)arrayUpValueWithArray:(NSArray *)array
{
   return [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
      return [obj1 compare:obj2];//升序
   }];
}

- (void)requestProductDetailWithProductName:(NSString *)name shopID:(NSString *)shopID
{
    if (!name && !shopID) {
        return;
    }
     __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [APPCT.netWorkService GET:kSDYNetWorkProductDetailUrl parameters:@{@"name":name,@"shop_id":shopID} success:^(NSDictionary *data, NSString *errorDescription) {
            __strong typeof(weakSelf)strongSelf = self;
            
            NSInteger requestStatus = [data[status] integerValue];
            NSString *backMessage = data[message];
            if (requestStatus != 0) {
                return ;
            }
            NSDictionary *dic = data[@"data"];
            APPCT.productDetailModel = [ProductDetailModel cz_objWithDict:dic];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.detailModel = APPCT.productDetailModel;
            });
        } faile:^(NSString *errorDescription) {
            
        }];
    });
    
   
}

//清除数据
- (void)clearData
{
    self.numberTextField.text = @"0";
    self.gradeBtnTagArray = [NSMutableArray array];
    self.unitBtnTagArray = [NSMutableArray array];
    self.priceWithTagArray = [NSMutableArray array];
}


#pragma mark - getter and setter

- (void)setDetailModel:(ProductDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    self.productModel = detailModel.product[ProductDetailProductKey];
    
    [self.attributesCollectionView reloadData];
    [self.shopTableView reloadData];

    self.nameLabel.text = self.productModel.product_name;
    self.detailTextView.text = self.productModel.product_description;
    self.shopNameLabel.text = self.productModel.shop_name;
    self.priceLabel.text = [NSString stringWithFormat:@"请在下面选择规格"];
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.productModel.thumbnail ? kSDYImageUrl(self.productModel.thumbnail) : nil]];
    
//    [self.detailModel.shops enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        ProductDetailShopModel *shopModel = obj;
//        if ([self.productModel.shop_name isEqualToString:shopModel.shop_name]) {
//            [self.shopTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
//        }
//    }];
    
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

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithTextColor:[UIColor redColor] font:18];
        _priceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _priceLabel;
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
        _reduceNumberBtn.layer.borderWidth = 1;
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
        _addNumberBtn.layer.borderWidth = 1;
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

- (UICollectionView *)attributesCollectionView
{
    if (!_attributesCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(60, 40);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.headerReferenceSize = CGSizeMake(60, 40);
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        _attributesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _attributesCollectionView.delegate = self;
        _attributesCollectionView.dataSource = self;
        _attributesCollectionView.allowsMultipleSelection = YES;
        
        
        [_attributesCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ProductDetailViewCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:ProductDetailViewCollectionCellIdentifier];
        
        [_attributesCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ProductDetailViewCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ProductDetailViewCollectionReusableViewIdentifier];
        
        _attributesCollectionView.backgroundColor = [UIColor clearColor];
    }
    return _attributesCollectionView;
}

- (NSMutableArray *)gradeBtnTagArray
{
    if (!_gradeBtnTagArray) {
        _gradeBtnTagArray = [NSMutableArray array];
    }
    return _gradeBtnTagArray;
}

- (NSMutableArray *)unitBtnTagArray
{
    if (!_unitBtnTagArray) {
        _unitBtnTagArray = [NSMutableArray array];
    }
    return _unitBtnTagArray;
}

- (NSMutableArray *)priceWithTagArray
{
    if (!_priceWithTagArray) {
        _priceWithTagArray = [NSMutableArray array];
    }
    return _priceWithTagArray;
}

- (void)dealloc
{
    self.gradeBtnTagArray = [NSMutableArray array];
    self.unitBtnTagArray = [NSMutableArray array];
    self.priceWithTagArray = [NSMutableArray array];
    self.detailModel = nil;
    self.productModel = nil;
}


@end
