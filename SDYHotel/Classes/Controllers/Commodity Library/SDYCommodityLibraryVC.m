//
//  SDYCommodityLibraryVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYCommodityLibraryVC.h"
#import "ProductModle.h"
#import "ProductCategoryModel.h"
#import "ProductDetailModel.h"
#import "ProductShopCartModel.h"

#import "ProductLibraryCollectionCell.h"
#import "ProductLibraryOrderCell.h"

#import "ProductDetailView.h"
#import "ProductOrderCartTableFootView.h"



static NSString *const CategoryTableViewCellIdentifier = @"CommodityLibraryCatagoryTableViewCellIdentifier";
static NSString *const ClassTableViewCellIdentifier = @"CommodityLibraryClassTableViewCellIdentifier";
static NSString *const ProductCollectionCellIdentifier = @"CommodityLibraryProductCollectionCellIdentifier";
static NSString *const OrderTableViewCellIdentifier = @"CommodityLibraryOrderTableViewCellIdentifier";


@interface SDYCommodityLibraryVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ProductDetailViewDelegate,ProductOrderCartTableFootViewDelegate>


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
@property (nonatomic) ProductDetailView *detailView;

/**
 购物车 下面备注和下单
 */
@property (nonatomic) ProductOrderCartTableFootView *footView;

/**
 商品详情的黑色背景
 */
@property (nonatomic) UIButton *blackView;

/**
 购物车下面的 备注  下单
 */
@property (nonatomic) ProductOrderCartTableFootView *orderCartFootView;

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

@end

@implementation SDYCommodityLibraryVC

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"商品库";
    
    [self.view addSubview:self.categoryTableView];
    [self.view addSubview:self.classTableView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.orderTableView];
    [self.view addSubview:self.orderCartFootView];
    
    [self layoutWithAuto];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (APPCT.viewModel.productCategorysAry.count == 0) {
        self.selectCellIndex = 0;
        [self requestProductCategoryWithPid:nil];
    }
}


#pragma mark - Delegate

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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == tableViewTagCommodityLibraryProductCategory) {
        return @"全部分类";
    }
    if (tableView.tag == tableViewTagCommodityLibraryProductClass) {
        return @"分类描述";
    }
    if (tableView.tag == tableViewTagCommodityLibraryProductOrder) {
        return @"订单";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if (tableView.tag == tableViewTagCommodityLibraryProductOrder) {
//        啥也不做
    }
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
        ProductCategoryModel *sectionModel = APPCT.viewModel.productCategorysAry[indexPath.row];
        cell.textLabel.text = sectionModel.category_name;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.selectedBackgroundView = [self cellSelectViewWithSize:cell.bounds.size];
        return cell;
    }
    
    if (tableView.tag == tableViewTagCommodityLibraryProductClass) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassTableViewCellIdentifier forIndexPath:indexPath];
        
        if (APPCT.viewModel.productCategorysAry.count > 0) {
            ProductCategoryModel *sectionModel = APPCT.viewModel.productCategorysAry[self.selectCellIndex];
            ProductCategoryModel *cellModel = sectionModel.children[indexPath.row];
            cell.textLabel.text = cellModel.category_name;
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.selectedBackgroundView = [self cellSelectViewWithSize:cell.bounds.size];
        }
        return cell;
    }
    if (tableView.tag == tableViewTagCommodityLibraryProductOrder) {
        ProductLibraryOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderTableViewCellIdentifier forIndexPath:indexPath];
        __weak typeof(self)weakSelf = self;
        cell.shopCartModel = self.productOrderArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;;
        [cell cellDeleteBtnClick:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.productOrderArray removeObjectAtIndex:indexPath.row];
            [strongSelf.orderTableView reloadData];
        }];
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModle *model = APPCT.viewModel.productsAry[indexPath.row];
    [self requestProductDetailWithProductID:model.product_id];
#pragma mark - 测试  完成之后使用上面
   
//    [self requestProductDetailWithProductID:@"531"];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionIsReloadData ? APPCT.viewModel.productsAry.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductLibraryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductCollectionCellIdentifier forIndexPath:indexPath];

    ProductModle *model = APPCT.viewModel.productsAry[indexPath.row];
    cell.title.text = model.product_name;
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
    selectView.backgroundColor = kUIColorFromRGB(0x06ce8a);
    cell.selectedBackgroundView = selectView;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - ProductDetailViewDelegate

- (void)productDetailViewCompleteBtnClickHidenWhiteContentView:(ProductShopCartModel *)shopCartModel
{
#pragma mark - 这里把detail View 的数据处理
    
    [self hideDetailView];

    if (!shopCartModel) {
        return;
    }
    
    //判断 是否存在这个数据
    __block  BOOL isContain = NO;

    
    [self.productOrderArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
            ProductShopCartModel *model = obj;

            if (shopCartModel.productName == model.productName && shopCartModel.shopName == model.shopName && shopCartModel.unitPrice == model.unitPrice) {
               
                model.number +=shopCartModel.number;
                model.unitPrice = shopCartModel.unitPrice;
                model.unit = shopCartModel.unit;
                isContain = YES;
            }
        }];
    if (!isContain) {
        [self.productOrderArray addObject:shopCartModel];
    }
    
    [self.orderTableView reloadData];
    
    }

#pragma mark - ProductOrderCartTableFootViewDelegate

//xidan
- (void)placeOrderClickWithRemarkStr:(NSString *)remarkStr
{
    
    if (!APPCT.isLogin) {
        
        [APPCT showLoginViewCon];
        return;
    }
    
    if (self.productOrderArray.count == 1) {
        [self alertTitle:@"请先选择商品" message:nil complete:nil];
        return;
    }
    
#pragma mark - 根据购物车里的row 添加东西，暂时没想到如何 合并相同供应商，商品名 的数据
    
//    NSString *content =  [self placeOrderPushServiceContentWithRemark:remarkStr productAry:self.productOrderArray];
    
    //博旭
    NSArray *cartAry = [self arrayElementApppend:self.productOrderArray.copy remark:remarkStr];
    NSString *content = [self placeOrderPushServiceContentProductOrderModelAry:cartAry];

//    NSLog(@"请求数据 = %@",content);
    //下单
    [self requestAddNewOrderWithContent:content];
}


#pragma mark - Private method

- (void)layoutWithAuto
{
    [self.categoryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
        make.top.left.equalTo(self.view);
        make.width.mas_equalTo(120);
    }];
    [self.classTableView mas_makeConstraints:^(MASConstraintMaker *make) {

        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
        make.top.equalTo(self.view);
        make.left.equalTo(self.categoryTableView.mas_right);
        make.width.equalTo(self.categoryTableView);
    }];
   
    [self.orderCartFootView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.right.equalTo(self.view);
        make.width.mas_equalTo(120*4);
        make.height.mas_equalTo(150);
    }];
    
    [self.orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.right.equalTo(self.view);
        make.width.equalTo(self.orderCartFootView);
        make.bottom.equalTo(self.orderCartFootView.mas_top);
    }];
    
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
        make.left.equalTo(self.classTableView.mas_right);
        make.top.equalTo(self.view);
        make.right.equalTo(self.orderTableView.mas_left);
    }];
}

/**
 请求商品分类 with  pid (父级分类id)

 @param pid 父级分类id
 */
- (void)requestProductCategoryWithPid:(NSInteger)pid
{
    NSDictionary *parmeters = [NSDictionary dictionary];
    if (pid) {
        parmeters = @{@"pid":[NSString stringWithFormat:@"%ld",pid]};
    } else {
        parmeters = nil;
    }
    
    __weak typeof(self)WeakSelf = self;
    [APPCT.netWorkService GET:kSDYNetWorkProductCategoryUrl parameters:parmeters success:^(NSDictionary *data, NSString *errorDescription) {
        
        NSInteger requestStatus = [data[status] integerValue];
        NSString *backMessage = data[message];
        if (requestStatus != 0) {
            [WeakSelf alertTitle:backMessage message:nil complete:nil];
        }
        
        NSArray *dataAry = data[@"data"];
        
        NSMutableArray *modelAry = [NSMutableArray array];
        [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProductCategoryModel *productCategoryModel =  [ProductCategoryModel cz_objWithDict:obj];
            [modelAry addObject:productCategoryModel];
        }];
        APPCT.viewModel.productCategorysAry = modelAry;
        
        [WeakSelf.categoryTableView reloadData];
        [WeakSelf.classTableView reloadData];
        
        //默认选中第一行
        [WeakSelf.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    } faile:^(NSString *errorDescription) {
        [WeakSelf alertTitle:errorDescription message:nil complete:nil];
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
    [APPCT.netWorkService GET:kSDYNetWorkProductListUrl parameters:parameters success:^(NSDictionary *data, NSString *errorDescription) {
        NSInteger requestStatus = [data[status] integerValue];
        NSString *backMessage = data[message];
        if (requestStatus !=0 ) {
            [self alertTitle:backMessage message:nil complete:nil];
            return ;
        }
        NSArray *array = data[@"data"];//@[ @{},@{}]
        
        NSMutableArray *productModelsAry = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProductModle *model = [ProductModle cz_objWithDict:obj];
            [productModelsAry addObject:model];
        }];
    
        APPCT.viewModel.productsAry = productModelsAry;
//        [WeakSelf.collectionView reloadData];
        WeakSelf.collectionIsReloadData = YES;
        
    } faile:^(NSString *errorDescription) {
        [self alertTitle:errorDescription message:nil complete:nil];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APPCT.netWorkService GET:kSDYNetWorkProductDetailUrl parameters:@{@"id":productid} success:^(NSDictionary *data, NSString *errorDescription) {
            
            __strong typeof(WeakSelf)strongSelf = WeakSelf;
            
            NSInteger requestStatus = [data[status] integerValue];
            NSString *backMessage = data[message];
            
            if (requestStatus != 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf alertTitle:backMessage message:nil complete:nil];
                });
                return ;
            }
            /*
             attributes @[]   product @{}  shops @{}  skus @{}
             */
            NSDictionary *dic = data[@"data"];
            APPCT.productDetailModel = [ProductDetailModel cz_objWithDict:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showDetailView];
            });
        } faile:^(NSString *errorDescription) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WeakSelf alertTitle:errorDescription message:nil complete:nil];
            });
        }];
    });
}

//- (void)requestProductDetailWithProductID:(NSString *)productid
- (void)requestAddNewOrderWithContent:(NSString *)content
{
    
    if (!content) {
        [self alertTitle:@"没有商品信息" message:nil complete:nil];
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [APPCT.netWorkService POST:kSDYNetWorkAddNewOrderUrl parameters:@{@"content": content} success:^(NSDictionary *data, NSString *errorDescription) {
            
            NSInteger requestStatus = [data[status] integerValue];
            NSString *backMessage = data[message];
            
            if (requestStatus != 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf alertTitle: backMessage message:nil complete:nil];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf alertTitle:@"下单成功" message:nil complete:nil];
                    
                    [strongSelf.productOrderArray removeObjectsInRange:NSMakeRange(1, strongSelf.productOrderArray.count - 1)];
                    [strongSelf.orderTableView reloadData];
                });
            }
        } fail:^(NSString *errorDescription) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf alertTitle:errorDescription message:nil complete:nil];
            });
        }];
    });
    
}


/**
 显示商品详情界面
 */
- (void)showDetailView
{
    self.detailView.detailModel = APPCT.productDetailModel;
    [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = self.detailView.frame;
        frame.origin.y = kScreenHeight /3;
        self.detailView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 隐藏商品详情
 */
- (void)hideDetailView
{
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = self.detailView.frame;
        frame.origin.y = kScreenHeight;
        self.detailView.frame = frame;
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self.detailView  clearData];
    }];
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
    [modelArray removeObjectAtIndex:0];
    
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
        
        [orderModel.details addObject:orderDetailModel];
        
        
        for (NSInteger j = i+1 >= modelArray.count ? 0 : i+1; j < modelArray.count; j++) {
            
            if (j >= modelArray.count || j == 0) {
                break;
            }
            
              ProductShopCartModel *shopCartModel2 = modelArray[j];
            
            if (shopCartModel.shopName == shopCartModel2.shopName && shopCartModel.productName == shopCartModel2.productName) {
                
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
    
    return resultArray;
}


#pragma mark - Getter and Setter

- (void)setCollectionIsReloadData:(BOOL)collectionIsReloadData
{
    _collectionIsReloadData = collectionIsReloadData;
    [self.collectionView reloadData];
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
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(170, 50);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"ProductLibraryCollectionCell" bundle:nil] forCellWithReuseIdentifier:ProductCollectionCellIdentifier];
    }
    return _collectionView;
}

- (UITableView *)orderTableView
{
    if (!_orderTableView) {
        _orderTableView = [self tableViewDefault];
        _orderTableView.tag = tableViewTagCommodityLibraryProductOrder;
        [_orderTableView registerClass:[ProductLibraryOrderCell class] forCellReuseIdentifier:OrderTableViewCellIdentifier];
    }
    return _orderTableView;
}

- (ProductDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[ProductDetailView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight*2/3)];
        _detailView.delegate = self;
    }
    return _detailView;
}

- (UIButton *)blackView
{
    if (!_blackView) {
        _blackView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_blackView addTarget:self action:@selector(hideDetailView) forControlEvents:UIControlEventTouchUpInside];
        [_blackView addSubview:self.detailView];
    }
    return _blackView;
}

- (ProductOrderCartTableFootView *)orderCartFootView
{
    if (!_orderCartFootView) {
        _orderCartFootView = [[ProductOrderCartTableFootView alloc] init];
        _orderCartFootView.delegate = self;
    }
    return _orderCartFootView;
}



- (NSMutableArray *)productOrderArray
{
    if (!_productOrderArray) {
        _productOrderArray = [NSMutableArray array];
        ProductShopCartModel *shopCartModel = [[ProductShopCartModel alloc] init];
        shopCartModel.isSection = YES;
        [_productOrderArray addObject:shopCartModel];
    }
    return _productOrderArray;
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
    selectView.backgroundColor = kUIColorFromRGB(0x06ce8a);
    return selectView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
