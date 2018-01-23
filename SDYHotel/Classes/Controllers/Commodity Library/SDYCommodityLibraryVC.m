//
//  SDYCommodityLibraryVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYCommodityLibraryVC.h"

#import "ProductCategoryModel.h"
#import "ProductDetailModel.h"
#import "ProductShopCartModel.h"
#import "SDYBaseNavigationVC.h"

#import "ProductLibraryOrderCell.h"

#import "ProductCollectionCell.h"
#import "SDYHistoryRecordCell.h"//



#import "ProductOrderCartTableFootView.h"
#import "SDYCommodityLibraryOrderHeader.h"

#import "SDYSearchProductVC.h"

#import "SDYCommodityLibraryProductDetailView.h"


static NSString *const CategoryTableViewCellIdentifier = @"CommodityLibraryCatagoryTableViewCellIdentifier";
static NSString *const ClassTableViewCellIdentifier = @"CommodityLibraryClassTableViewCellIdentifier";
static NSString *const ProductCollectionCellIdentifier = @"CommodityLibraryProductCollectionCellIdentifier";
static NSString *const OrderTableViewCellIdentifier = @"CommodityLibraryOrderTableViewCellIdentifier";

static NSString *const OrderTableViewFooterIdentifier = @"CommodityLibraryOrderTableViewFooterIdentifier";
static NSString *const OrderTableViewHeaderIdentifier = @"CommodityLibraryOrderTableViewHeaderIdentifier";


@interface SDYCommodityLibraryVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDYCommodityLibraryProductDetailViewDelegate,UISearchBarDelegate>


/**
 第一级分类
 */
@property (nonatomic) UITableView *categoryTableView;
/**
 第二级分类
 */
@property (nonatomic) UITableView *classTableView;
/**
 分类里面商品的列表
 */
@property (nonatomic) UICollectionView *collectionView;
/**
 类似于购物车
 */
@property (nonatomic) UITableView *orderTableView;
/**
 从下面弹出商品详情
 */
//@property (nonatomic) ProductDetailView *detailView;

/** 显示商品详情的 */
@property (nonatomic) SDYCommodityLibraryProductDetailView *secondDetailView;

/**
 购物车 下面备注和下单
 */
@property (nonatomic) ProductOrderCartTableFootView *footView;

/**
 商品详情的黑色背景
 */
@property (nonatomic) UIButton *blackView;

/**
 是否刷新collectionView
 */
@property (nonatomic, assign) BOOL collectionIsReloadData;

/**
 选择滑动的row  第一分类选择的row  ，用来确定第二分类DataSource
 */
@property (nonatomic) NSInteger selectCellIndex;

/**
 保存购物车product 数据
 */
@property (nonatomic) NSMutableArray *productOrderArray;

@property (nonatomic) UISearchBar *searchBar;




@end

@implementation SDYCommodityLibraryVC
{
    CGFloat _width;
    CGFloat _height;
    
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _width = self.view.bounds.size.width;
    _height = self.view.bounds.size.height;
    self.productOrderArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setNavigatonBar];
    
    [self.view addSubview:self.categoryTableView];
    [self.view addSubview:self.classTableView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.orderTableView];

    [self layoutWithAuto];
    
    Add_Observer(SDYMyRecordSelectProductNotification, @selector(notificationMyRecordSelectProduct:));
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (APPCT.viewModel.productCategorysAry.count == 0) {
        self.selectCellIndex = 0;
        [self requestProductCategoryWithPid:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark - Event response  相应事件

/** 已废弃 */
- (void)searchBtnClick
{
    SDYSearchProductVC *searVC = [[SDYSearchProductVC alloc] init];
    searVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searVC animated:NO];
}
/** 在iPad titleView为UISearchBar 取消按钮不显示 */
- (void)rightItemButtonCancelClick
{
    [self.searchBar resignFirstResponder];
}
/** 从我的收藏点击商品 跳转到商品库来添加商品 */
- (void)notificationMyRecordSelectProduct:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self requestProductDetailWithProductID:dic[@"product_id"]];
    });
}

#pragma mark - Delegate 代理方法

#pragma mark - UITalbeViewDelegate
//UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag == tableViewTagCommodityLibraryProductOrder) {
        return 150;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == tableViewTagCommodityLibraryProductCategory) {
        return [self setupTableSectionHeaderLabelText:@"全部分类"];
    }
    if (tableView.tag == tableViewTagCommodityLibraryProductClass) {
        return [self setupTableSectionHeaderLabelText:@"分类描述"];
    }

    if (tableView.tag == tableViewTagCommodityLibraryProductOrder) {
        
        SDYCommodityLibraryOrderHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderTableViewHeaderIdentifier];
        header.titlesAry = @[@"商品名",@"规格",@"数量*单价",@"小计"];
        return header;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag == tableViewTagCommodityLibraryProductOrder) {
        
        __weak typeof(self)weakSelf = self;
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        ProductOrderCartTableFootView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderTableViewFooterIdentifier];
        footerView.downOrderButtonClick = ^(NSString *remark) {
            
            if (!APPCT.isLogin) {
                [APPCT showLoginViewCon];
                return;
            }
            
            if (strongSelf.productOrderArray.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"请先选择商品"];
                [SVProgressHUD dismissWithDelay:1.0];
                return;
            }
            
            NSArray *cartAry = [strongSelf arrayElementApppend:strongSelf.productOrderArray.copy remark:remark];
            NSString *content = [strongSelf placeOrderPushServiceContentProductOrderModelAry:cartAry];
            
            //    NSLog(@"请求数据 = %@",content);
            //下单
            [strongSelf requestAddNewOrderWithContent:content];
        };
        
        return footerView;
    }
    UIView *footViewClear = [[UIView alloc] initWithFrame:CGRectZero];
    footViewClear.backgroundColor = [UIColor clearColor];
    return footViewClear;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (APPCT.viewModel.productCategorysAry.count == 0) {
        return;
    }
    
    if (tableView.tag == tableViewTagCommodityLibraryProductCategory) {
        self.selectCellIndex = indexPath.row;
        [self.classTableView reloadData];
        
        self.collectionIsReloadData = NO;
    }
    if (tableView.tag == tableViewTagCommodityLibraryProductClass) {

        ProductCategoryModel *sectionModel = APPCT.viewModel.productCategorysAry[self.selectCellIndex];
        ProductCategoryModel *cellModel = sectionModel.children[indexPath.row];
    
        [self requestProductWithCat:cellModel.category_id name:nil page:nil line:nil];
    }
    //类似购物车表 没有点击事件
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == tableViewTagCommodityLibraryProductCategory) {
        return APPCT.viewModel.productCategorysAry.count;
    }
    if (tableView.tag == tableViewTagCommodityLibraryProductClass) {

        if (APPCT.viewModel.productCategorysAry.count > 0) {
            ProductCategoryModel *sectionModel = APPCT.viewModel.productCategorysAry[self.selectCellIndex];
            return sectionModel.children.count;
        }
    }
    if (tableView.tag == tableViewTagCommodityLibraryProductOrder) {
        return self.productOrderArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == tableViewTagCommodityLibraryProductCategory) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryTableViewCellIdentifier forIndexPath:indexPath];
        //基本cell的设置
         [self setupTableCell:cell];
        
        ProductCategoryModel *sectionModel = APPCT.viewModel.productCategorysAry[indexPath.row];
        cell.textLabel.text = sectionModel.category_name;
        return cell;
    }
    
    if (tableView.tag == tableViewTagCommodityLibraryProductClass) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassTableViewCellIdentifier forIndexPath:indexPath];
        //基本cell的设置
        [self setupTableCell:cell];
        if (APPCT.viewModel.productCategorysAry.count > 0) {
            ProductCategoryModel *sectionModel = APPCT.viewModel.productCategorysAry[self.selectCellIndex];
            ProductCategoryModel *cellModel = sectionModel.children[indexPath.row];
            cell.textLabel.text = cellModel.category_name;
        }
        return cell;
    }
    if (tableView.tag == tableViewTagCommodityLibraryProductOrder) {
        
        ProductLibraryOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderTableViewCellIdentifier forIndexPath:indexPath];
        __weak typeof(self)weakSelf = self;
        __strong typeof(weakSelf)strongSelf = weakSelf;
        cell.shopCartModel = self.productOrderArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;;
        [cell cellDeleteBtnClick:^{
            
            [strongSelf alertTitle:@"确认删除" message:nil complete:^{
                /** 重新赋值为了setter 方法的执行 */
                NSMutableArray *ary = strongSelf.productOrderArray;
                [ary removeObjectAtIndex:indexPath.row];
                strongSelf.productOrderArray = ary;
                [strongSelf.orderTableView reloadData];
            }];
        }];
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [self.navigationController.navigationBar endEditing:YES];
    
    ProductDetailProductModel *model = APPCT.viewModel.productsAry[indexPath.row];
    [self requestProductDetailWithProductID:model.product_id];

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionIsReloadData ? APPCT.viewModel.productsAry.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    SDYHistoryRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductCollectionCellIdentifier forIndexPath:indexPath];
    
    ProductDetailProductModel *model = APPCT.viewModel.productsAry[indexPath.row];
    cell.title.text = model.product_name;
    return cell;
}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self rightItemButtonCancelClick];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self requestProductWithCat:nil name:searchBar.text page:nil line:nil];
}


#pragma mark - ProductDetailViewDelegate

- (void)productDetailViewCompleteBtnClickHidenWhiteContentView:(ProductShopCartModel *)shopCartModel
{
#pragma mark - 这里把detail View 的数据处理
    
    if (!shopCartModel) {
        return;
    }
    
    //判断 是否存在这个数据
    __block  BOOL isContain = NO;
#pragma mark - 使用赋值操作是为了 Setter 方法的执行
    NSMutableArray *array = self.productOrderArray;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
            ProductShopCartModel *model = obj;

            if (shopCartModel.productName == model.productName && shopCartModel.shopName == model.shopName && shopCartModel.unitPrice == model.unitPrice) {
               
                model.number +=shopCartModel.number;
                model.unitPrice = shopCartModel.unitPrice;
                model.unit = shopCartModel.unit;
                isContain = YES;
            }
        }];
    if (!isContain) {
        [array addObject:shopCartModel];
    }
    
    self.productOrderArray = array;
    [self.orderTableView reloadData];
}

- (void)productDetailViewRecordProductBtnClickProductID:(NSString *)productID isRecord:(BOOL)isRecord
{
    if (!APPCT.isLogin) {
       
        [self.secondDetailView hideView];
        [APPCT showLoginViewCon];
        return;
    }
    [APPCT.netWorkService GET:isRecord ? kAPIURLCancelRecordProduct : kAPIURLRecordProduct  parameters:@{@"pid":productID} success:^(NSDictionary *dictionary) {
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:dictionary[message]];
        [SVProgressHUD dismissWithDelay:1.0];
    
    } faile:^(NSString *errorDescription) {
        [SVProgressHUD showErrorWithStatus:errorDescription];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}


#pragma mark - Private method

/** 设置导航条 */
- (void)setNavigatonBar
{
    self.navigationItem.titleView = self.searchBar;
    if (!kIsIphone) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemButtonCancelClick)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

/** 布局 */
- (void)layoutWithAuto
{

    [self.categoryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.bottom.equalTo(self.view);
            make.top.equalTo(self.view);
        }
        make.left.equalTo(self.view);
        make.width.mas_equalTo(kIsIphone ? 80 : 120);
    }];
    [self.classTableView mas_makeConstraints:^(MASConstraintMaker *make) {

        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
        make.top.equalTo(self.view);
        make.left.equalTo(self.categoryTableView.mas_right).mas_offset(0.8);
        make.width.equalTo(self.categoryTableView);
    }];
    
    if (kIsIphone) {
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
            make.left.equalTo(self.classTableView.mas_right).mas_offset(0.5);
            make.top.equalTo(self.view);
            make.width.mas_equalTo((kScreenWidth-100)*2/5);
        }];
        
    } else {
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
            make.left.equalTo(self.classTableView.mas_right).mas_offset(0.5);
            make.top.equalTo(self.view);
            make.width.mas_equalTo((kScreenWidth-100)*2/5);
        }];
    }
    
    [self.orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.left.equalTo(self.collectionView.mas_right).mas_offset(0.5);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.bottom.equalTo(self.view);
            make.top.equalTo(self.view);
        }
    }];
}

/** 设置cell 的基本设置 */
- (void)setupTableCell:(UITableViewCell *)cell
{
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:kCellFont];
    cell.selectedBackgroundView = [self cellSelectViewWithSize:cell.bounds.size];
}
/** 显示第二个 商品详情 */
- (void)showProductSecondDetailView:(ProductDetailModel *)model
{
    self.secondDetailView.productDetailModel = model;
    [self.secondDetailView showView];
}


/**
 请求商品分类 with  pid (父级分类id)

 @param pid 父级分类id
 */
- (void)requestProductCategoryWithPid:(NSString *)pid
{
    NSDictionary *parmeters = [NSDictionary dictionary];
    if (pid) {
        parmeters = @{@"pid":pid};
    } else {
        parmeters = nil;
    }
    
    __weak typeof(self)WeakSelf = self;
    __strong typeof(WeakSelf)strongSelf = WeakSelf;
    
    [APPCT.netWorkService GET:kAPIURLProductCategory parameters:parmeters success:^(NSDictionary *dictionary) {
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        NSArray *dataAry = dictionary[@"data"];
        
        NSMutableArray *modelAry = [NSMutableArray array];
        [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProductCategoryModel *productCategoryModel =  [ProductCategoryModel cz_objWithDict:obj];
            [modelAry addObject:productCategoryModel];
        }];
        APPCT.viewModel.productCategorysAry = modelAry;
        
        [strongSelf.categoryTableView reloadData];
        [strongSelf.classTableView reloadData];
        
        //默认选中第一行
        [strongSelf.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    } faile:^(NSString *errorDescription) {
        [SVProgressHUD showErrorWithStatus:errorDescription];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}

/**
 请求商品列表 cat 商品分类id  name 商品名称 page 当前页码  line 每页的行数

 @param cat 商品分类id
 @param name 商品名称
 @param page 当前页码
 @param line 每页的行数
 */
- (void)requestProductWithCat:(NSString *)cat name:(NSString *)name page:(NSString *)page line:(NSString *)line
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (cat) {
        [parameters setObject:cat forKey:@"cat"];
    }
    if (name) {
        [parameters setObject:name forKey:@"name"];
    }
    if (page) {
        [parameters setObject:page forKey:@"p"];
    }
    if (line) {
        [parameters setObject:line forKey:@"len"];
    }
    __weak typeof(self)WeakSelf = self;
    __strong typeof(WeakSelf)strongSelf = WeakSelf;
    
    [APPCT.netWorkService GET:kAPIURLProductList parameters:parameters success:^(NSDictionary *dictionary) {
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus !=0 ) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        NSArray *array = dictionary[@"data"];//@[ @{},@{}]
        
        NSMutableArray *productModelsAry = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProductDetailProductModel *model = [ProductDetailProductModel cz_objWithDict:obj];
            [productModelsAry addObject:model];
        }];
        
        APPCT.viewModel.productsAry = productModelsAry;
        strongSelf.collectionIsReloadData = YES;
    } faile:^(NSString *errorDescription) {
        [SVProgressHUD showErrorWithStatus:errorDescription];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}

/**
 请求商品详情 使用id 商品 id （或者使用 name 商品名称 ，shop_id 商品所属店铺id）

 @param productid 商品 id
 */
- (void)requestProductDetailWithProductID:(NSString *)productid
{
    if (!productid) {
        return;
    }
    
    __weak typeof(self)WeakSelf = self;
    __strong typeof(WeakSelf)strongSelf = WeakSelf;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APPCT.netWorkService GET:kAPIURLProductDetail parameters:@{@"id":productid} success:^(NSDictionary *dictionary) {
            NSInteger requestStatus = [dictionary[status] integerValue];
            if (requestStatus != 0) {
                [SVProgressHUD showErrorWithStatus:dictionary[message]];
                [SVProgressHUD dismissWithDelay:1.0];
                return ;
            }
            /*
             attributes @[]   product @{}  shops @{}  skus @{}
             */
            NSDictionary *dic = dictionary[@"data"];
            ProductDetailModel *productDetailModel = [ProductDetailModel cz_objWithDict:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showProductSecondDetailView:productDetailModel];
            });
        } faile:^(NSString *errorDescription) {
            [SVProgressHUD showErrorWithStatus:errorDescription];
            [SVProgressHUD dismissWithDelay:1.0];
        }];
    });
}

/** 新订单 */
- (void)requestAddNewOrderWithContent:(NSString *)content
{
    if (!content) {
        [self alertTitle:@"没有商品信息" message:nil complete:nil];
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [APPCT.netWorkService POST:kAPIURLAddNewOrder parameters:@{@"content": content} success:^(NSDictionary *dictionary) {
            NSInteger requestStatus = [dictionary[status] integerValue];

            if (requestStatus != 0) {
                [SVProgressHUD showErrorWithStatus:dictionary[message]];
                [SVProgressHUD dismissWithDelay:1.0];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{                    
                    [strongSelf.productOrderArray removeAllObjects];
                    [strongSelf.orderTableView reloadData];
                    
                    
                    [SVProgressHUD showSuccessWithStatus:@"success"];
                    [SVProgressHUD dismissWithDelay:1.0];
                });
            }
        } fail:^(NSString *errorDescription) {
            [SVProgressHUD showErrorWithStatus:errorDescription];
            [SVProgressHUD dismissWithDelay:1.0];
        }];
    });
}


/**
 下单请求content 字符串  使用remark  shopCartDataSource

 @param remark 备注
 @param productAry 购物车数据
 @return content 字符串
 */
- (NSString *)placeOrderPushServiceContentWithRemark:(NSString *)remark productAry:(NSMutableArray *)productAry
{
    
    NSMutableArray *array = [NSMutableArray array];
    [productAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx != 0) {
            
            ProductShopCartModel *shopCartModel = obj;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:shopCartModel.shopModel.shop_id forKey:shop_id];
            [dic setObject:shopCartModel.shopModel.shop_name forKey:shop_name];
            [dic setObject:shopCartModel.shopModel.master_phone forKey:shop_phone];
            [dic setObject:APPCT.loginUser.user_id forKey:user_id];
            [dic setObject:APPCT.loginUser.user_name forKey:user_name];
            [dic setObject:shopCartModel.toalPrice forKey:@"price"];
            [dic setObject:remark forKey:content];
            
            
            NSMutableArray *ary = [NSMutableArray array];
            NSMutableDictionary *detailDic = [NSMutableDictionary dictionary];
            [detailDic setObject:@"" forKey:detail_id];
            [detailDic setObject:shopCartModel.skusModel.sku_id forKey:sku_id];
            [detailDic setObject:shopCartModel.skusModel.product_name forKey:@"product_name"];
            [detailDic setObject:shopCartModel.skusModel.product_id forKey:product_id];
            [detailDic setObject:shopCartModel.attributes forKey:attributes];
            [detailDic setObject:shopCartModel.skusModel.mall_price forKey:@"price"];
            [detailDic setObject:[NSString stringWithFormat:@"%d",shopCartModel.number] forKey:quantity];
            [detailDic setObject:shopCartModel.unit forKey:@"unit"];
            
            [ary addObject:detailDic];
            
            [dic setObject:ary forKey:@"details"];
            
            [array addObject:dic];
        }
    }];
        
    
    NSError *error ;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return jsonResult;
}


/**
 下单请求content 字符串  ProductOrderModel

 @param orderAry ProductOrderModel ary
 @return json content string
 */
- (NSString *)placeOrderPushServiceContentProductOrderModelAry:(NSArray *)orderAry
{
    NSMutableArray *resultAry = [NSMutableArray array];
    
    [orderAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ProductOrderModel *orderModel = obj;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:orderModel.shopID forKey:shop_id];
        [dic setObject:orderModel.shopName forKey:shop_name];
        [dic setObject:orderModel.shopPhone forKey:shop_phone];
        [dic setObject:APPCT.loginUser.user_id forKey:user_id];
        [dic setObject:APPCT.loginUser.user_name forKey:user_name];
        [dic setObject:orderModel.totalPrice forKey:@"price"];
        [dic setObject:orderModel.content forKey:content];
        
        NSMutableArray *detailAry = [NSMutableArray array];
        [orderModel.details enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *detailDic = [NSMutableDictionary dictionary];
            ProductOrderDetailModel *orderDetailModel = obj;
          
            [detailDic setObject:orderDetailModel.detail_id forKey:detail_id];
            [detailDic setObject:orderDetailModel.product_name forKey:@"product_name"];
            [detailDic setObject:orderDetailModel.product_id forKey:product_id];
            [detailDic setObject:orderDetailModel.attributes forKey:attributes];
            [detailDic setObject:orderDetailModel.mall_price forKey:@"price"];
            [detailDic setObject:orderDetailModel.quantity forKey:quantity];
            [detailDic setObject:orderDetailModel.unit forKey:@"unit"];
            [detailDic setObject:orderDetailModel.sku_id forKey:sku_id];
            
            [detailAry addObject:detailDic];
        }];
        [dic setObject:detailAry forKey:@"details"];
        
        [resultAry addObject:dic];
    }];
    
    
    NSError *error ;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultAry options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return jsonResult;
}


//
///**
// 返回合并后的数组 model为ProductOrderModel
//
// @param array 购物车model 数组ProductShopCartModel
// @param remark 备注
// @return 合并后的数组ProductOrderModel
// */
//- (NSArray *)arrayElementApppend:(NSMutableArray *)array remark:(NSString *)remark
//{
//    //不使用copy  防止原数组修改
//    NSMutableArray *modelArray = [NSMutableArray arrayWithArray:array];
//
//    NSMutableArray *resultArray = [NSMutableArray array];
//
//    for (NSInteger i = 0; i < modelArray.count; i ++) {
//
//        ProductShopCartModel *shopCartModel = modelArray[i];
//
//
//        ProductOrderModel *orderModel = [[ProductOrderModel alloc] init];
//        orderModel.shopName = shopCartModel.shopName;
//        orderModel.shopID = shopCartModel.shopModel.shop_id;
//        orderModel.shopPhone = shopCartModel.shopModel.master_phone;
//        orderModel.userID = APPCT.loginUser.user_id;
//        orderModel.userName = APPCT.loginUser.user_name;
//        orderModel.content = remark;
//        orderModel.totalPrice = shopCartModel.toalPrice;
//
//
//        ProductOrderDetailModel *orderDetailModel = [[ProductOrderDetailModel alloc] init];
//        orderDetailModel.detail_id = @"";
//        orderDetailModel.sku_id = shopCartModel.skusModel.sku_id;
//        orderDetailModel.product_name = shopCartModel.skusModel.product_name;
//        orderDetailModel.product_id = shopCartModel.skusModel.product_id;
//        orderDetailModel.attributes = shopCartModel.attributes;
//        orderDetailModel.mall_price = [NSString stringWithFormat:@"%.2f",shopCartModel.unitPrice];
//        orderDetailModel.quantity = [NSString stringWithFormat:@"%d",shopCartModel.number];
//        orderDetailModel.unit = shopCartModel.unit;
//
//        [orderModel.details addObject:orderDetailModel];
//
//
//        for (NSInteger j = i+1 >= modelArray.count ? 0 : i+1; j < modelArray.count; j++) {
//
//            if (j >= modelArray.count || j == 0) {
//                break;
//            }
//
//              ProductShopCartModel *shopCartModel2 = modelArray[j];
//
//            if (shopCartModel.shopName == shopCartModel2.shopName) {
//
//                orderModel.totalPrice = [NSString stringWithFormat:@"%.2f",[shopCartModel.toalPrice floatValue] + [shopCartModel2.toalPrice floatValue]];
//
//                ProductOrderDetailModel *orderDetailModel2 = [[ProductOrderDetailModel alloc] init];
//                orderDetailModel2.detail_id = @"";
//                orderDetailModel2.sku_id = shopCartModel2.skusModel.sku_id;
//                orderDetailModel2.product_name = shopCartModel2.skusModel.product_name;
//                orderDetailModel2.product_id = shopCartModel2.skusModel.product_id;
//                orderDetailModel2.attributes = shopCartModel2.attributes;
//                orderDetailModel2.mall_price = [NSString stringWithFormat:@"%.2f",shopCartModel2.unitPrice];
//                orderDetailModel2.quantity = [NSString stringWithFormat:@"%d",shopCartModel2.number];
//                orderDetailModel2.unit = shopCartModel2.unit;
//                [orderModel.details addObject:orderDetailModel2];
//            }
//        }
//        [resultArray addObject:orderModel];
//    }
//
//    return resultArray;
//}

#pragma mark - 合并数据出现问题 

/**
 返回合并后的数组 model为ProductOrderModel
 
 @param array 购物车model 数组ProductShopCartModel
 @param remark 备注
 @return 合并后的数组ProductOrderModel
 */
- (NSArray *)arrayElementApppend:(NSMutableArray *)array remark:(NSString *)remark
{
    //不使用copy  防止原数组修改
    NSMutableArray *modelArray = [NSMutableArray arrayWithArray:array];
    //最终结果的数组
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < modelArray.count; i ++) {
        
        ProductShopCartModel *shopCartModel = modelArray[i];
        
        ProductOrderModel *orderModel = [[ProductOrderModel alloc] init];
        orderModel.shopName = shopCartModel.shopName;
        orderModel.shopID = shopCartModel.shopModel.shop_id;
        orderModel.shopPhone = shopCartModel.shopModel.master_phone;
        orderModel.userID = APPCT.loginUser.user_id;
        orderModel.userName = APPCT.loginUser.user_name;
        orderModel.content = remark;
        orderModel.totalPrice = shopCartModel.toalPrice;
        
        ProductOrderDetailModel *orderDetailModel = [[ProductOrderDetailModel alloc] init];
        orderDetailModel.detail_id = @"";
        orderDetailModel.sku_id = shopCartModel.skusModel.sku_id;
        orderDetailModel.product_name = shopCartModel.skusModel.product_name;
        orderDetailModel.product_id = shopCartModel.skusModel.product_id;
        orderDetailModel.attributes = shopCartModel.attributes;
        orderDetailModel.mall_price = [NSString stringWithFormat:@"%.2f",shopCartModel.unitPrice];
        orderDetailModel.quantity = [NSString stringWithFormat:@"%d",shopCartModel.number];
        orderDetailModel.unit = shopCartModel.unit;
    
        //添加数据
        [orderModel.details addObject:orderDetailModel];

        //数组中 元素后面的元素比较
        for (NSInteger j = i+1 >= modelArray.count ? 0 : i+1; j < modelArray.count; j++) {

            if (j >= modelArray.count || j == 0) {
                break;
            }

              ProductShopCartModel *shopCartModel2 = modelArray[j];

            if (shopCartModel.shopName == shopCartModel2.shopName) {

                orderModel.totalPrice = [NSString stringWithFormat:@"%.2f",[shopCartModel.toalPrice floatValue] + [shopCartModel2.toalPrice floatValue]];

                ProductOrderDetailModel *orderDetailModel2 = [[ProductOrderDetailModel alloc] init];
                orderDetailModel2.detail_id = @"";
                orderDetailModel2.sku_id = shopCartModel2.skusModel.sku_id;
                orderDetailModel2.product_name = shopCartModel2.skusModel.product_name;
                orderDetailModel2.product_id = shopCartModel2.skusModel.product_id;
                orderDetailModel2.attributes = shopCartModel2.attributes;
                orderDetailModel2.mall_price = [NSString stringWithFormat:@"%.2f",shopCartModel2.unitPrice];
                orderDetailModel2.quantity = [NSString stringWithFormat:@"%d",shopCartModel2.number];
                orderDetailModel2.unit = shopCartModel2.unit;
                
                [orderModel.details addObject:orderDetailModel2];
            }
        }
        [resultArray addObject:orderModel];
    }
    
    /**  删除相同供应商 的商品少的商品 */
    resultArray = (NSMutableArray *)[self arrayRemoveArray:(NSArray *)resultArray];

    return resultArray;
}

/** 删除元素 */
- (NSArray *)arrayRemoveArray:(NSArray *)array
{
    NSMutableArray *array2 = [NSMutableArray arrayWithArray:array];
    for (NSInteger i = 0; i < array.count; i++) {
        
        ProductOrderModel *orderModel = array[i];
        
        for (NSInteger j = i+1 >= array.count ? 0 : i+1; j < array.count; j++) {
            
            if (j >= array.count || j == 0) {
                break;
            }
            ProductOrderModel *orderModel2 = array[j];
            
            if (orderModel.shopID == orderModel2.shopID) {
                
                if (orderModel.details.count > orderModel2.details.count) {
                    [array2 removeObject:orderModel2];
                } else {
                    [array2 removeObject:orderModel];
                }
            }
        }
    }
    return array2.copy;
}

/** 设置tableview section header label */
- (UILabel *)setupTableSectionHeaderLabelText:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = kSDYBgViewColor;
    titleLabel.font = [UIFont systemFontOfSize:kCellFont];
    titleLabel.text = title;
    return titleLabel;
}

#pragma mark - Getter and Setter

- (void)setCollectionIsReloadData:(BOOL)collectionIsReloadData
{
    _collectionIsReloadData = collectionIsReloadData;
    [self.collectionView reloadData];
}

- (void)setProductOrderArray:(NSMutableArray *)productOrderArray
{
    _productOrderArray = productOrderArray;
    
    if (_productOrderArray.count >= 1) {
        
        __block float total  = 0;

        [_productOrderArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProductShopCartModel *model = obj;
            total += [model.toalPrice floatValue];
        }];
        
        ProductOrderCartTableFootView *footer = [self.orderTableView footerViewForSection:0];
        footer.orderTotalPrice = [NSString stringWithFormat:@"%.2f",total];
    }
}

- (UITableView *)categoryTableView
{
    if (!_categoryTableView) {
        _categoryTableView = [self tableViewDefault];
        _categoryTableView.tag = tableViewTagCommodityLibraryProductCategory;
        [_categoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CategoryTableViewCellIdentifier];
    }
    return _categoryTableView;
}

- (UITableView *)classTableView
{
    if (!_classTableView) {
        
        _classTableView = [self tableViewDefault];
        _classTableView.tag = tableViewTagCommodityLibraryProductClass;
        [_classTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ClassTableViewCellIdentifier];
    }
    return _classTableView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.5;
        layout.minimumInteritemSpacing = 0.5;
        
        layout.itemSize = CGSizeMake(((kScreenWidth-100)*2/5 -2)/2, kIsIphone ? 60 : 80);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.backgroundColor = kSDYBgViewColor;
    //使用有图片的cell
//        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ProductCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:ProductCollectionCellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SDYHistoryRecordCell class]) bundle:nil] forCellWithReuseIdentifier:ProductCollectionCellIdentifier];
    }
    return _collectionView;
}

- (UITableView *)orderTableView
{
    if (!_orderTableView) {
        _orderTableView = [self tableViewDefault];
        _orderTableView.tag = tableViewTagCommodityLibraryProductOrder;
        _orderTableView.showsVerticalScrollIndicator = YES;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        titleLabel.text = @"已选商品";
        titleLabel.backgroundColor = kSDYBgViewColor;
        _orderTableView.tableHeaderView = titleLabel;
        
        [_orderTableView registerClass:[ProductLibraryOrderCell class] forCellReuseIdentifier:OrderTableViewCellIdentifier];
        [_orderTableView registerClass:[ProductOrderCartTableFootView class] forHeaderFooterViewReuseIdentifier:OrderTableViewFooterIdentifier];
        [_orderTableView registerClass:[SDYCommodityLibraryOrderHeader class] forHeaderFooterViewReuseIdentifier:OrderTableViewHeaderIdentifier];
        
    }
    return _orderTableView;
}

- (SDYCommodityLibraryProductDetailView *)secondDetailView
{
    if (!_secondDetailView) {
        _secondDetailView = [[SDYCommodityLibraryProductDetailView alloc] init];
        _secondDetailView.delegete  = self;
    }
    return _secondDetailView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = YES;
        _searchBar.placeholder = @"搜索商品 搜索的结果显示在正下方列表";
        _searchBar.tintColor = [UIColor blackColor];
    }
    return _searchBar;
}

- (UITableView *)tableViewDefault
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    return tableView;
}

- (UIView *)cellSelectViewWithSize:(CGSize)size
{
    UIView *selectView = [[UIView alloc] init];
    selectView.frame = CGRectMake(0, 0, size.width,size.height);
    selectView.backgroundColor = kSDYColorGreen;
    return selectView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
