//
//  SDYRecordVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYRecordVC.h"
#import "ProductDetailModel.h"
#import "ProductCollectionCell.h"
#import "SDYCommodityLibraryProductDetailView.h"
#import "Masonry.h"


static NSString *const MyRecordCollectionCellIdentifier = @"MyRecordCollectionCellIdentifier";

@interface SDYRecordVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDYCommodityLibraryProductDetailViewDelegate>

@property (nonatomic) NSMutableArray *dataSource;

@property (nonatomic) UICollectionView *productCollectionView;

@property (nonatomic) SDYCommodityLibraryProductDetailView *detailView;



@end

@implementation SDYRecordVC
{
    NSInteger _cellSelectIndex;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的收藏";
    [self.view addSubview:self.productCollectionView];
    
    [self.productCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!APPCT.isLogin) {
       
        [APPCT showLoginViewCon];
        return;
    }
    [self requestRecordProductList];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.detailView hideView];
}

#pragma mark - Delegate


#pragma mark - UICollectionViewDeletate  九宫格的代理实现
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _cellSelectIndex = indexPath.row;
    ProductDetailProductModel *productModel = self.dataSource[indexPath.row];
//    [self requestProductDetailWithProductID:productModel.product_id];
    
   //跳转到商品库 显示商品详情
    self.tabBarController.selectedIndex = 1;
    Post_Observer(SDYMyRecordSelectProductNotification, nil, @{@"product_id":productModel.product_id});
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;//根据section设置每个section的item个数
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //cell的重用，在设置UICollectionView 中注册了cell
    ProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyRecordCollectionCellIdentifier forIndexPath:indexPath];
    cell.productModel = self.dataSource[indexPath.row];//设置cell的数据
    return cell;
}
#pragma mark - SDYCommodityLibraryProductDetailViewDelegate 详情视图的代理

- (void)productDetailViewCompleteBtnClickHidenWhiteContentView:(ProductShopCartModel *)shopCartModel
{
    NSLog(@"确定");
    [self alertTitle:@"需要添加购物车" message:nil
            complete:nil];
}

- (void)productDetailViewRecordProductBtnClickProductID:(NSString *)productID isRecord:(BOOL)isRecord
{
    if (!APPCT.isLogin) {
        
        [self.detailView hideView];
        [APPCT showLoginViewCon];
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    sdy_asyncDispatchToGlobalQueue(^{
        [APPCT.netWorkService GET: isRecord ? kAPIURLCancelRecordProduct : kAPIURLRecordProduct  parameters:@{@"pid":productID} success:^(NSDictionary *dictionary) {
            
            NSInteger requestStatus = [dictionary[status] integerValue];
            if (requestStatus != 0) {
                [SVProgressHUD showErrorWithStatus:dictionary[message]];
                [SVProgressHUD dismissWithDelay:1.0];
                return ;
            }
            [SVProgressHUD showSuccessWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            
            [self.dataSource removeObjectAtIndex:_cellSelectIndex];
            
            sdy_asyncDispatchToMainQueue(^{
                [strongSelf.productCollectionView reloadData];
                [strongSelf.detailView hideView];
            });
            
        } faile:^(NSString *errorDescription) {
            [SVProgressHUD showErrorWithStatus:errorDescription];
            [SVProgressHUD dismissWithDelay:1.0];
        }];
    });
}

#pragma mark - Event response




#pragma mark - Private method
#pragma mark - 网络请求
/** 请求收藏列表 */
- (void)requestRecordProductList
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    [APPCT.netWorkService GET:kAPIURLReocrdProductList parameters:@{@"uid":APPCT.loginUser.user_id} success:^(NSDictionary *dictionary) {
        
        if ([dictionary[status] integerValue] != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        
        NSArray *products = dictionary[@"data"];
        NSMutableArray *array = [NSMutableArray array];
        [products enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProductDetailProductModel *detailProductModel = [ProductDetailProductModel cz_objWithDict:obj];
            [array addObject:detailProductModel];
        }];
        strongSelf.dataSource = array;
        [strongSelf.productCollectionView reloadData];
        
    } faile:^(NSString *errorDescription) {
        [SVProgressHUD showErrorWithStatus:errorDescription];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}
/** 查看详情 */
- (void)requestProductDetailWithProductID:(NSString *)productid
{
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
            ProductDetailModel *model = [ProductDetailModel cz_objWithDict:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showProductDetailViewWithProductDetailModel:model];
            });
        } faile:^(NSString *errorDescription) {
            [SVProgressHUD showErrorWithStatus:errorDescription];
            [SVProgressHUD dismissWithDelay:1.0];
        }];
    });
}
//
///** 取消关注 */
//- (void)requestCancelRecordWithProductID:(NSString *)productID
//{
//    __weak typeof(self)WeakSelf = self;
//    __strong typeof(WeakSelf)strongSelf = WeakSelf;
//    sdy_asyncDispatchToGlobalQueue(^{
//
//        [APPCT.netWorkService GET:kAPIURLCancelRecordProduct parameters:@{@"pid":productID} success:^(NSDictionary *dictionary) {
//
//            NSInteger requestStatus = [dictionary[status] integerValue];
//            if (requestStatus !=0) {
//                sdy_asyncDispatchToMainQueue(^{
//                    [strongSelf alertTitle:dictionary[message] message:nil complete:nil];
//                });
//            } else {
//                sdy_asyncDispatchToMainQueue(^{
//                    [strongSelf.dataSource removeObjectAtIndex:_cellSelectIndex];
//                    [strongSelf.productCollectionView reloadData];
//                });
//            }
//        } faile:^(NSString *errorDescription) {
//            sdy_asyncDispatchToMainQueue(^{
//                [strongSelf alertTitle:errorDescription message:nil complete:nil];
//            });
//        }];
//    });
//}

#pragma mark - 显示隐藏商品详情视图

- (void)showProductDetailViewWithProductDetailModel:(ProductDetailModel *)detailModel
{
    self.detailView.productDetailModel = detailModel;
    [self.detailView showView];
}


#pragma mark - Getter and Setter

- (UICollectionView *)productCollectionView
{
    if (!_productCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;  //行间距
        flowLayout.minimumInteritemSpacing = 5; //列间距
        flowLayout.estimatedItemSize = CGSizeMake(50, 50);  //预定的itemsize
        flowLayout.itemSize = CGSizeMake(150, 100); //固定的itemsize
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滑动的方向 垂直
        //初始化 UICollectionView
        _productCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _productCollectionView.delegate = self; //设置代理
        _productCollectionView.dataSource = self;   //设置数据来源
        _productCollectionView.backgroundColor = kSDYBgViewColor;

        _productCollectionView.bounces = YES;   //设置弹跳
        _productCollectionView.alwaysBounceVertical = YES;  //只允许垂直方向滑动
        //注册 cell 使用NIB  也可以使用代码 registerClassxxxx
        [_productCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ProductCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:MyRecordCollectionCellIdentifier];
    }
    return _productCollectionView;
}

- (SDYCommodityLibraryProductDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[SDYCommodityLibraryProductDetailView alloc] init];
        _detailView.delegete = self;
        _detailView.isCancelRecord = YES;
    }
    return _detailView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
