//
//  SDYCommodityLibraryProductDetailView.m
//  SDYHotel
//
//  Created by admin on 2018/1/2.
//  Copyright © 2018年 SanDaoYi. All rights reserved.
//

#import "SDYCommodityLibraryProductDetailView.h"
#import "SDYAddSubtractNumber.h"
#import "SDYProductDetailAttrivuteCell.h"

#import "ProductDetailModel.h"
#import "ProductShopCartModel.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImageView+HighlightedWebCache.h>

#import "UIImage+Category.h"


static NSString *const attributeCellIdentifier = @"SDYCommodityLibraryProductDetailViewAttributeCellIdentifier";
static NSString *const shopCellIdentifier = @"SDYCommodityLibraryProductDetailViewShopCellIdentifier";

@interface SDYCommodityLibraryProductDetailView ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic) UIView *blackView;
@property (nonatomic) UIView *whiteView;
/** 商品icon */
@property (nonatomic) UIImageView *productIconImageView;
/** 商品name */
@property (nonatomic) UILabel *productNameLabel;
/** 商品供应商 */
@property (nonatomic) UILabel *productShopNameLabel;
/** 商品详情介绍 */
@property (nonatomic) UITextView *productDetailTextView;
/** 商品属性列表 */
@property (nonatomic) UITableView *productAttributeTableView;

/** 供应商列表 */
@property (nonatomic) UITableView *shopTableView;

/** 完成确定button */
@property (nonatomic) UIButton *compleButton;
/** 收藏 */
@property (nonatomic) UIButton *recordButton;

/** 商品数量 */
@property (nonatomic) SDYAddSubtractNumber *addSubtractNumber;
/** 选中的cell的indexpath row */
@property (nonatomic, assign) NSUInteger cellIndex;
/** 选择的商品的价格 默认为第一个 */
@property (nonatomic) NSString *productPrice;
///** 商品的属性 */
//@property (nonatomic) NSString *productAttribute;
///** 单位 */
//@property (nonatomic) NSString *productUnit;
/** 商店的model */
@property (nonatomic) ProductDetailShopModel *shopModel;
/** 选择单品的model */
@property (nonatomic) ProductDetailSkusModel *skusModel;
/** 请求的商品model */
@property (nonatomic) ProductDetailProductModel *productModel;


@end


@implementation SDYCommodityLibraryProductDetailView

- (instancetype)init
{
    if (self = [super init]) {
    
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        [self addSubview:self.blackView];
        [self addSubview:self.whiteView];
        [self setupWhiteView];
    }
    return self;
}

#pragma mark - Event response
/** 显示 */
- (void)showView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //使用transform 进行平移
    self.blackView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.whiteView.transform = CGAffineTransformMakeTranslation(0, -self.whiteView.bounds.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}
/** 隐藏 */
- (void)hideView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.whiteView.transform = CGAffineTransformMakeTranslation(0, self.whiteView.bounds.size.height);
    } completion:^(BOOL finished) {
        self.blackView.hidden = YES;
        [self removeFromSuperview];
        [self clearData];
    }];
}
/** 确定按钮buttonclick */
- (void)compleButtonClick:(UIButton *)sender
{
    ProductShopCartModel *cartModel = [[ProductShopCartModel alloc] init];
    cartModel.productName = self.productNameLabel.text;
    cartModel.shopName = self.productShopNameLabel.text;

    cartModel.number = [self.addSubtractNumber.text intValue];
    cartModel.unitPrice = [self.productPrice floatValue];
    cartModel.unit = self.productModel.unit;
    cartModel.shopModel = self.shopModel;
    cartModel.skusModel = self.skusModel;
    cartModel.attributes = self.skusModel.attribute_names;
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(productDetailViewCompleteBtnClickHidenWhiteContentView:)]) {
        [self.delegete productDetailViewCompleteBtnClickHidenWhiteContentView:cartModel];
    }
    [self hideView];
}


/** 收藏按钮click */
- (void)recordButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    self.isCancelRecord = !self.isCancelRecord;
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(productDetailViewRecordProductBtnClickProductID: isRecord:)]) {
        [self.delegete productDetailViewRecordProductBtnClickProductID:self.productModel.product_id isRecord:self.isCancelRecord];
    }
}

#pragma mark - Delegate UITableViewDelegate  列表的代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == tableViewTagCommodityLibraryProductDetailShop) {
        
        if (self.productDetailModel.shops.count > 0) {
            self.shopModel = self.productDetailModel.shops[indexPath.row];
            
            [self requestProductDetailWithProductName:self.productModel.product_name shopID:self.shopModel.shop_id];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.productDetailModel) {
        return 0;
    }
    
    if (tableView.tag == tableViewTagCommodityLibraryProductDetailAttribute)    return self.productDetailModel.skus.count;
    
    if (tableView.tag == tableViewTagCommodityLibraryProductDetailShop)
        return self.productDetailModel.shops.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == tableViewTagCommodityLibraryProductDetailAttribute) {
        SDYProductDetailAttrivuteCell *cell = [tableView dequeueReusableCellWithIdentifier:attributeCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak typeof(self)weakSelf = self;
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        if (self.productDetailModel && self.productDetailModel.skus.count != 0) {
            ProductDetailSkusModel *skusModel = self.productDetailModel.skus[indexPath.row];
            
            cell.productUnit = self.productModel.unit;
//            cell.attribute = [self attributeWithAttributeNumber:skusModel.attributes  attributeAry:self.productDetailModel.attributes];
            
            cell.attribute = skusModel.attribute_names;
            cell.mallPrice = skusModel.mall_price;
            cell.makePrice = skusModel.market_price;
    
            cell.index = indexPath.row;
            
            if (indexPath.row == self.cellIndex) {
                cell.buttonIsSelected = YES;
            } else {
                cell.buttonIsSelected = NO;
            }
            
            cell.attributeBtnClick = ^(NSUInteger index) {
                strongSelf.cellIndex = index;
                strongSelf.productPrice = skusModel.mall_price;
                strongSelf.skusModel = skusModel;
                [strongSelf.productAttributeTableView reloadData];
            };
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCellIdentifier forIndexPath:indexPath];
    if (self.productDetailModel && self.productDetailModel.shops.count != 0) {
        ProductDetailShopModel *shopModel = self.productDetailModel.shops[indexPath.row];
        cell.textLabel.text = shopModel.shop_name;
        cell.textLabel.numberOfLines = 2;
        
    }
    return cell;
}

#pragma mark - Private medhtod

- (void)setupWhiteView
{
    CGFloat width = self.whiteView.bounds.size.width;
    CGFloat height = self.whiteView.bounds.size.height;
    CGFloat shopTableWidth = 200;
    
    self.productAttributeTableView.frame = CGRectMake(0, 0, width - shopTableWidth -10, height);
    self.shopTableView.frame = CGRectMake(width-shopTableWidth, 0, shopTableWidth, height);
    
    [self.whiteView addSubview:self.productAttributeTableView];
    [self.whiteView addSubview:self.shopTableView];
    
    [self setupTableHeader];
    [self setupTableFooter];

}

- (void)setupTableHeader
{
    CGFloat width = self.productAttributeTableView.bounds.size.width;
    
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
    
    self.productIconImageView.frame = CGRectMake(5, 5, kIconWidth, kIconWidth);
    self.productNameLabel.frame = CGRectMake(CGRectGetMaxX(self.productIconImageView.frame)+10, 5, width - (CGRectGetMaxX(self.productIconImageView.frame) + 10), kIconWidth/2);
    
    self.productShopNameLabel.frame = CGRectMake(CGRectGetMinX(self.productNameLabel.frame), CGRectGetMaxY(self.productNameLabel.frame), CGRectGetWidth(self.productNameLabel.bounds), kIconWidth/2);

    self.productDetailTextView.frame = CGRectMake(5, CGRectGetMaxY(self.productIconImageView.frame), width, kIconWidth);
    
    [tableHeader addSubview:self.productIconImageView];
    [tableHeader addSubview:self.productNameLabel];
    [tableHeader addSubview:self.productShopNameLabel];
    [tableHeader addSubview:self.productDetailTextView];
    
    CGRect frame = tableHeader.frame;
    frame.size.height = CGRectGetMaxY(self.productDetailTextView.frame);
    tableHeader.frame = frame;

    self.productAttributeTableView.tableHeaderView = tableHeader;
}

- (void)setupTableFooter
{
    CGFloat width = self.productAttributeTableView.bounds.size.width;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 35)];
    label.text = @"请选择数量";
    self.addSubtractNumber.frame = CGRectMake(width-120, 2.5, 110, 30);
    self.recordButton.frame = CGRectMake(width/2 - 150, CGRectGetMaxY(self.addSubtractNumber.frame)+5, 130, 35);
    
    self.compleButton.frame = CGRectMake(width/2 + 20, CGRectGetMinY(self.recordButton.frame), 80, 35);
    
    [footer addSubview:label];
    [footer addSubview:self.addSubtractNumber];
    [footer addSubview:self.recordButton];
    [footer addSubview:self.compleButton];
    
    CGRect frame = footer.frame;
    frame.size.height = CGRectGetMaxY(self.compleButton.frame) + 20;
    footer.frame = frame;
    
    self.productAttributeTableView.tableFooterView = footer;
}

/**
 请求不同的供应商的数据   参数 商品name 供应商id

 @param name 商品名称
 @param shopID 供应商id
 */
- (void)requestProductDetailWithProductName:(NSString *)name shopID:(NSString *)shopID
{
    if (!name && !shopID) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [APPCT.netWorkService GET:kAPIURLProductDetail parameters:@{@"name":name,@"shop_id":shopID} success:^(NSDictionary *dictionary) {
            
            NSInteger requestStatus = [dictionary[status] integerValue];
            if (requestStatus != 0) {
                return ;
            }
            NSDictionary *dic = dictionary[@"data"];

            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.productDetailModel = [ProductDetailModel cz_objWithDict:dic];
            });
            
        } faile:^(NSString *errorDescription) {
            
            [SVProgressHUD showErrorWithStatus:errorDescription];
            [SVProgressHUD dismissWithDelay:1.0];
        }];
    });
}
/** 清理数据 */
- (void)clearData
{
    self.addSubtractNumber.text = @"1";
    self.cellIndex = 0;
    [self.productAttributeTableView setContentOffset:CGPointZero animated:YES];
    self.isCancelRecord = NO;
}

#pragma mark - Getter and Setter

- (void)setProductDetailModel:(ProductDetailModel *)productDetailModel
{
    _productDetailModel = productDetailModel;

    if (_productDetailModel.skus.count > 0) {
        self.skusModel = _productDetailModel.skus[0];
        self.productPrice = self.skusModel.mall_price;
        self.cellIndex = 0;
    }
    if (_productDetailModel.shops.count > 0) {
        self.shopModel = _productDetailModel.shops[0];
        self.productShopNameLabel.text = self.shopModel.shop_name;
    }
    
    [self.productAttributeTableView reloadData];
    [self.shopTableView reloadData];
    
    self.productModel = _productDetailModel.product[ProductDetailProductKey];
    [self.productIconImageView sd_setImageWithURL:[NSURL URLWithString:kSDYImageUrl(self.productModel.thumbnail)] placeholderImage:[UIImage imageNamed:@"icon_error"]];
    self.productNameLabel.text = self.productModel.product_name;
    self.productDetailTextView.text = self.productModel.product_description;

}

- (void)setIsCancelRecord:(BOOL)isCancelRecord
{
    _isCancelRecord = isCancelRecord;
//    [self.recordButton setTitle:_isCancelRecord ? @"取消收藏" : @"收藏" forState: UIControlStateNormal];
    NSString *imageName = _isCancelRecord ? @"icon_favorites_select" : @"icon_favorites_unSelect";
    [self.recordButton setImage:[UIImage sizeImageWithImage:[UIImage imageNamed:imageName] sizs:CGSizeMake(25, 25)] forState:UIControlStateNormal];
}


- (UIView *)blackView
{
    if (!_blackView) {
        _blackView = [[UIView alloc] initWithFrame:self.bounds];
        _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _blackView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [_blackView addGestureRecognizer:tap];
    }
    return _blackView;
}

- (UIView *)whiteView
{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight*3/4)];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

- (UITableView *)productAttributeTableView
{
    if (!_productAttributeTableView) {
        _productAttributeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _productAttributeTableView.delegate = self;
        _productAttributeTableView.dataSource = self;
        _productAttributeTableView.tag = tableViewTagCommodityLibraryProductDetailAttribute;
        [_productAttributeTableView registerClass:[SDYProductDetailAttrivuteCell class] forCellReuseIdentifier:attributeCellIdentifier];
    }
    return _productAttributeTableView;
}

- (UIImageView *)productIconImageView
{
    if (!_productIconImageView) {
        _productIconImageView = [[UIImageView alloc] init];
    }
    return _productIconImageView;
}

- (UILabel *)productNameLabel
{
    if (!_productNameLabel) {
        _productNameLabel = [[UILabel alloc] init];
        _productNameLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:kCellFont];
    }
    return _productNameLabel;
}

- (UILabel *)productShopNameLabel
{
    if (!_productShopNameLabel) {
        _productShopNameLabel = [[UILabel alloc] init];
        _productShopNameLabel.font = [UIFont systemFontOfSize:kCellFont];
        _productShopNameLabel.textColor = [UIColor blackColor];
    }
    return _productShopNameLabel;
}
- (UITextView *)productDetailTextView
{
    if (!_productDetailTextView) {
        _productDetailTextView = [[UITextView alloc] init];
        _productDetailTextView.editable = NO;
        _productDetailTextView.selectable = NO;
        _productDetailTextView.font = [UIFont systemFontOfSize:13];
        _productDetailTextView.textColor = kUIColorFromRGB(0x999999);
    }
    return _productDetailTextView;
}

- (SDYAddSubtractNumber *)addSubtractNumber
{
    if (!_addSubtractNumber) {
        _addSubtractNumber = [[SDYAddSubtractNumber alloc] init];
    }
    return _addSubtractNumber;
}

- (UITableView *)shopTableView
{
    if (!_shopTableView) {
        _shopTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _shopTableView.delegate = self;
        _shopTableView.dataSource = self;
        _shopTableView.tag = tableViewTagCommodityLibraryProductDetailShop;
        [_shopTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:shopCellIdentifier];
    }
    return _shopTableView;
}

- (UIButton *)compleButton
{
    if (!_compleButton) {
        _compleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_compleButton setTitle:@"确定" forState:UIControlStateNormal];
        [_compleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_compleButton addTarget:self action:@selector(compleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _compleButton.layer.borderWidth = 0.75;
        _compleButton.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _compleButton;
}
- (UIButton *)recordButton
{
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_recordButton setTitle:@"收藏" forState:UIControlStateNormal];
        UIImage *image = [UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_favorites_unSelect"] sizs:CGSizeMake(25, 25)];
        
        [_recordButton setImage:image forState:UIControlStateNormal];
        [_recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_recordButton addTarget:self action:@selector(recordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _recordButton.layer.borderWidth = 0.75;
        _recordButton.layer.borderColor = [UIColor blackColor].CGColor;
        
    }
    return _recordButton;
}

- (void)dealloc
{
    
}


@end
