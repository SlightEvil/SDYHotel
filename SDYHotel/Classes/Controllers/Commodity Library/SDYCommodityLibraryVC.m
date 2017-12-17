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
#import "ProductLibraryCollectionCell.h"
#import "ProductDetailView.h"
//#import <SDWebImage/sdwebimage>

static NSString *const CategoryTableViewCellIdentifier = @"CommodityLibraryCatagoryTableViewCellIdentifier";
static NSString *const ClassTableViewCellIdentifier = @"CommodityLibraryClassTableViewCellIdentifier";
static NSString *const ProductCollectionCellIdentifier = @"CommodityLibraryProductCollectionCellIdentifier";
static NSString *const OrderTableViewCellIdentifier = @"CommodityLibraryOrderTableViewCellIdentifier";

@interface SDYCommodityLibraryVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ProductDetailViewDelegate>

@property (nonatomic) UITableView *categoryTableView;
@property (nonatomic) UITableView *classTableView;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UITableView *orderTableView;

@property (nonatomic) ProductDetailView *detailView;
@property (nonatomic) UIButton *blackView;


@property (nonatomic) NSInteger selectCellIndex;


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
    }
    if (tableView.tag == tableViewTagCommodityLibraryProductClass) {

        ProductCategoryModel *sectionModel = APPCT.viewModel.productCategorysAry[self.selectCellIndex];
        ProductCategoryModel *cellModel = sectionModel.children[indexPath.row];
    
        [self requestProductWithCat:cellModel.category_id name:nil page:nil line:nil];
    }
    if (tableView.tag == tableViewTagCommodityLibraryProductOrder) {
        
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
        return 3;
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderTableViewCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"购物车";
        return cell;
    }
    return nil;
//    UICollectionViewDelegate
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
    return APPCT.viewModel.productsAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductLibraryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductCollectionCellIdentifier forIndexPath:indexPath];

    ProductModle *model = APPCT.viewModel.productsAry[indexPath.row];
    cell.title.text = model.product_name;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - ProductDetailViewDelegate

- (void)productDetailViewCompleteBtnClickHidenWhiteContentView
{
#pragma mark - 这里把detail View 的数据处理
    //这里把detail View 的数据处理
    
    
    [self hideDetailView];
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
   
    [self.orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.top.right.equalTo(self.view);
        make.width.mas_equalTo(120*3);
        
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
        [WeakSelf.collectionView reloadData];
        
    } faile:^(NSString *errorDescription) {
        [self alertTitle:errorDescription message:nil complete:nil];
    }];
}

- (void)requestProductDetailWithProductID:(NSString *)productid
{
    if (!productid) {
        return;
    }
    
    __weak typeof(self)WeakSelf = self;
    
    [APPCT.netWorkService GET:kSDYNetWorkProductDetailUrl parameters:@{@"id":productid} success:^(NSDictionary *data, NSString *errorDescription) {
        
        __strong typeof(WeakSelf)strongSelf = WeakSelf;
        
        NSInteger requestStatus = [data[status] integerValue];
        NSString *backMessage = data[message];
        
        if (requestStatus != 0) {
            [strongSelf alertTitle:backMessage message:nil complete:nil];
            return ;
        }
        /*
         attributes @[]   product @{}  shops @{}  skus @{}
         */
        NSDictionary *dic = data[@"data"];
        APPCT.productDetailModel = [ProductDetailModel cz_objWithDict:dic];
        
        [strongSelf showDetailView];
        
    } faile:^(NSString *errorDescription) {
        [WeakSelf alertTitle:errorDescription message:nil complete:nil];
    }];
}

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

- (void)hideDetailView
{
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = self.detailView.frame;
        frame.origin.y = kScreenHeight;
        self.detailView.frame = frame;
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
    }];
}


#pragma mark - Getter and Setter

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
        [_orderTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:OrderTableViewCellIdentifier];
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
