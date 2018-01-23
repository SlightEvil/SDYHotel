//
//  SDYSearchProductVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/26.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYSearchProductVC.h"


#import "SDYHistoryRecordCell.h"
#import "SDYHistoryRecordCollecitonHeader.h"

#import "ProductDetailModel.h"

static NSString *const CollectionViewCellIdentifier = @"SDYHistoryRecordCollectionViewCellIdentifier";
static NSString *const CollectionViewHeaderIdentifier = @"SDYHistoryRecordCollectionViewHeaderIdentifier";


@interface SDYSearchProductVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (nonatomic) UISearchController *searchCon;

@property (nonatomic) UICollectionView *historyRecordCollectionView;

@property (nonatomic) NSMutableArray *dataSource;


@end

@implementation SDYSearchProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigatoinBar];
    
    self.historyRecordCollectionView.frame = self.view.bounds;
    [self.view addSubview:self.historyRecordCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchCon.searchBar becomeFirstResponder];
    });
}


#pragma mark - Delegate  代理

#pragma mark - UICollectionViewDelegate DataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        SDYHistoryRecordCollecitonHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionViewHeaderIdentifier forIndexPath:indexPath];

        header.clearHistoryRecordBtnClick = ^{
            
            NSMutableArray *array = [NSMutableArray array];
            strongSelf.dataSource = array;
            
            [APPCT userDefaultSave:array forKey:UDkHistoryRecoed];
            [strongSelf.historyRecordCollectionView reloadData];
        };
        return header;
    }
    
    UICollectionReusableView *footView = [[UICollectionReusableView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" 使用历史搜索 ");
    
    NSString *value = self.dataSource[indexPath.row];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.dataSource insertObject:value atIndex:0];
    [self.historyRecordCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDYHistoryRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    cell.title.text = self.dataSource[indexPath.row];
    
    cell.backgroundColor = [UIColor grayColor];
    
    return cell;
}

#pragma mark - UISearchBarDelegaet  搜索框代理

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"文字改变");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self requestProductWithCat:nil name:searchBar.text page:nil line:nil];
    
    
    NSLog(@"searchButtonClick");
    
    if ([self.dataSource containsObject:searchBar.text]) {
        [self.dataSource removeObject:searchBar.text];
    }
    [self.dataSource insertObject:searchBar.text atIndex:0];
    
    [self.historyRecordCollectionView reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Event response  相应事件

#pragma mark - Private methods  私有方法

- (void)setNavigatoinBar
{
    self.navigationItem.titleView = self.searchCon.searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
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
    } faile:^(NSString *errorDescription) {
        [SVProgressHUD showErrorWithStatus:errorDescription];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}

#pragma mark - Getter and Setter  懒加载  Set

- (UISearchController *)searchCon
{
    if (!_searchCon) {
    
        _searchCon = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchCon.searchBar.showsCancelButton = YES;
        //设置显示结果代理为 显示结果的控制器
        _searchCon.searchBar.delegate = self;
        _searchCon.hidesNavigationBarDuringPresentation = NO;
        _searchCon.searchBar.placeholder = @"搜索商品";
        _searchCon.dimsBackgroundDuringPresentation = NO;//是否显示灰色蒙版
        _searchCon.searchBar.barTintColor = [UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1];;
        /** 设置cancel 文字为完成 */
        //        [_searchCon.searchBar setValue:@"完成" forKey:@"_cancelButtonText"];
        
        //让取消一直显示，使用取消返回上一级视图
        _searchCon.searchBar.tintColor = [UIColor blueColor];

    }
    return _searchCon;
}

- (UICollectionView *)historyRecordCollectionView
{
    if (!_historyRecordCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.estimatedItemSize = CGSizeMake(40, 40);
        _historyRecordCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _historyRecordCollectionView.delegate = self;
        _historyRecordCollectionView.dataSource = self;
        _historyRecordCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_historyRecordCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SDYHistoryRecordCell class]) bundle:nil] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
        
        [_historyRecordCollectionView registerClass:[SDYHistoryRecordCollecitonHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionViewHeaderIdentifier];
        
    }
    return _historyRecordCollectionView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        
        NSArray *ary = [APPCT userDefaultVlaueForKey:UDkHistoryRecoed];
        if (!ary) {
            [APPCT userDefaultSave:array forKey:UDkHistoryRecoed];
        }
        _dataSource = array;
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
