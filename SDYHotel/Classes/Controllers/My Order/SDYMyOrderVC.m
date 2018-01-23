//
//  SDYMyOrderVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYMyOrderVC.h"
#import "UILabel+Category.h"
#import "Masonry.h"
#import <MJRefresh/MJRefresh.h>

#import "MyOrderOrderListModel.h"

#import "MyOrderListOrderCell.h"
#import "MyOrderAdvanceView.h"


static NSString *const MyOrderOrderListCellIdentifier = @"MyOrderOrderListCellIdentifier";


static NSString *const refreashPageLine = @"20";


@interface SDYMyOrderVC ()<UITableViewDelegate,UITableViewDataSource>

/** 订单列表 */
@property (nonatomic) UITableView *orderListTableView;

/** 订单列表 */
@property (nonatomic) NSMutableArray *orderListDataSource;

/** 预订单 */
@property (nonatomic) MyOrderAdvanceView *advanceView;
/** 配送单 */
@property (nonatomic) MyOrderAdvanceView *postView;

/** 分段选择器 */
@property (nonatomic) UISegmentedControl *segmentedControl;


@end

@implementation SDYMyOrderVC
{
/** 当前页数  */
    NSInteger _orderListPage;
/** 高度 */
    CGFloat _height;
/** 状态码 */
    NSUInteger _statusNumber;
/** 当前cell的index 删除cell使用 */
    NSUInteger _cellIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = [UIColor grayColor];
    
    _height = self.view.bounds.size.height-64;
    _cellIndex = 0;
    /*
     10 为 @“” 全部 segment.selectindex = 0
     0  为 1
     */
    _statusNumber = 10;// 为@""

    [self layoutWithFrame];

#pragma mark - 下拉刷新 上拉加载
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mjRefreshHeaderOrderListTableView)];
//    header.ignoredScrollViewContentInsetTop = -45;//忽略高度
    self.orderListTableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjRefreshFooterOrderListTableView)];
    self.orderListTableView.mj_footer = footer;
    
    Add_Observer(SDYMyOrderOrderWaitingForReceiveNotification, @selector(notificationOrderWaitingForReceive:));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!APPCT.isLogin) {
        
        [APPCT showLoginViewCon];
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestOrderListPage:@"1" pageLine:refreashPageLine status:_statusNumber == 10 ? @"":[NSString stringWithFormat:@"%zd",_statusNumber]];
        
        self.segmentedControl.selectedSegmentIndex = (_statusNumber == 10 ? 0 : _statusNumber+1);
    });
}

#pragma mark - Delegate

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderListDataSource) {
        _cellIndex = indexPath.row;
        
        self.advanceView.listModel = self.orderListDataSource[indexPath.row];
        self.postView.listModel = self.orderListDataSource[indexPath.row];
    }
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderOrderListCellIdentifier forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 2;
    MyOrderOrderListModel *listModel = self.orderListDataSource[indexPath.row];
    cell.textLabel.text = listModel.created_at;
    return cell;
}

#pragma mark - Event response

#pragma mark - 下拉刷新

- (void)mjRefreshHeaderOrderListTableView
{
    [self.orderListTableView setContentOffset:CGPointZero animated:YES];
    [self requestOrderListPage:@"1" pageLine:refreashPageLine status:_statusNumber == 10 ? @"":[NSString stringWithFormat:@"%zd",_statusNumber]];
}

- (void)mjRefreshFooterOrderListTableView
{
    [self requestOrderListPage:[NSString stringWithFormat:@"%zd",_orderListPage+1] pageLine:refreashPageLine status:_statusNumber == 10 ? @"":[NSString stringWithFormat:@"%zd",_statusNumber]];
}

- (void)mjRefreshHeader
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.orderListTableView.mj_header endRefreshing];
    });
}
/** 分段控制器选择订单状态 */
- (void)segmentedControlClickChangeOrderListWithStatus:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        _statusNumber = 10;
    } else {
        _statusNumber = sender.selectedSegmentIndex -1;
    }
    [self requestOrderListPage:@"1" pageLine:refreashPageLine status:_statusNumber == 10 ? @"" : [NSString stringWithFormat:@"%zd",_statusNumber]];
}

- (void)notificationOrderWaitingForReceive:(NSNotification *)notification
{
    _statusNumber = 2;
}


#pragma mark - Private method

- (void)layoutWithAuto
{
    [self.orderListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(150);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
}

- (void)layoutWithFrame
{

    CGFloat spaceHeight = 45;
    CGFloat viewWith = (kScreenWidth - 150)/2;
    
    
#pragma mark - 2.2  修改
    
    self.segmentedControl.frame = CGRectMake(0, 1, kScreenWidth, spaceHeight-2);
    self.orderListTableView.frame = CGRectMake(0, spaceHeight, 150, _height-spaceHeight);
    self.advanceView = [[MyOrderAdvanceView alloc] initWithAdvanceFrame:CGRectMake(CGRectGetMaxX(self.orderListTableView.frame)+1, spaceHeight, viewWith-2, _height-spaceHeight)];
    
    
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    self.postView = [[MyOrderAdvanceView alloc] initWithPostFrame:CGRectMake(CGRectGetMaxX(self.advanceView.frame)+1, spaceHeight, viewWith-2, _height-spaceHeight) compleBlock:^{
//        [strongSelf.orderListDataSource removeObjectAtIndex:_cellIndex];
//        [strongSelf.orderListTableView reloadData];
//        [strongSelf.orderListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndex:_cellIndex] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }];
    [self.view addSubview:self.orderListTableView];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.advanceView];
    [self.view addSubview:self.postView];
}

#pragma mark - 网络请求
/** 请求订单列表
 status
 0 订单已提交
 1订单待配送
 2 订单待确认收货
 3订单已完成  */
- (void)requestOrderListPage:(NSString *)pageNumber pageLine:(NSString *)pageLine status:(NSString *)statusNumber
{
    _orderListPage = [pageNumber integerValue];
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APPCT.netWorkService GET:kAPIURLOrderList parameters:@{page:pageNumber,line:pageLine,@"status":statusNumber} success:^(NSDictionary *dictionary) {         //@"status":@"2"
            
            NSInteger requestStetus = [dictionary[status] integerValue];
            NSString *backMessage = dictionary[message];
            
            if (requestStetus != 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.orderListTableView.mj_header endRefreshing];
                    [strongSelf.orderListTableView.mj_footer endRefreshing];
                    [SVProgressHUD showErrorWithStatus:backMessage];
                    [SVProgressHUD dismissWithDelay:1.0];
                });
                return ;
            }
            
            NSArray *dataAry = dictionary[@"data"];
            
            NSMutableArray *array = [NSMutableArray array];
            [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MyOrderOrderListModel *listModel = [MyOrderOrderListModel cz_objWithDict:obj];
                [array addObject:listModel];
            }];
            
            if ([pageNumber isEqualToString:@"1"]) {
                strongSelf.orderListDataSource = array;
                [strongSelf.orderListTableView reloadData];
                [strongSelf.orderListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                
                if (strongSelf.orderListDataSource.count >0) {
                    strongSelf.advanceView.listModel = strongSelf.orderListDataSource[0];
                    strongSelf.postView.listModel = strongSelf.orderListDataSource[0];
                }

            } else {
                NSMutableArray *array2 = strongSelf.orderListDataSource;
                [array2 addObjectsFromArray:array];
                strongSelf.orderListDataSource = array2;
                [strongSelf.orderListTableView reloadData];
            }
        
#pragma mark - 根据今天昨天添加到数组里面
            [strongSelf.orderListTableView.mj_header endRefreshing];
            [strongSelf.orderListTableView.mj_footer endRefreshing];
            
        } faile:^(NSString *errorDescription) {
            [strongSelf.orderListTableView.mj_header endRefreshing];
            [strongSelf.orderListTableView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:errorDescription];
            [SVProgressHUD dismissWithDelay:1.0];
        }];
    });
}

#pragma mark - 下拉刷新 设置图片
/**  设置普通状态的动画图片 */
- (NSArray *)IdleImageArray
{
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    
    return idleImages;
}
/** 设置即将刷新状态的动画图片（一松开就会刷新的状态)  设置正在刷新状态的动画图片 */
- (NSArray *)PullRefreshingImageAry
{
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    return refreshingImages;
}

#pragma mark - Getter and Setter

- (UITableView *)orderListTableView
{
    if (!_orderListTableView) {
        _orderListTableView = [self defaultTalbleView];
        _orderListTableView.tag = tableViewTagMyOrderOrderList;
        
        UILabel *label = [UILabel labelWithTextColor:nil font:18];
        label.text = @"日期";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        label.frame = CGRectMake(0, 0, 200, 45);
        _orderListTableView.tableHeaderView = label;
        
        [_orderListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MyOrderOrderListCellIdentifier];
    }
    return _orderListTableView;
}

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        NSArray *array = @[@"全部订单",@"订单已提交",@"订单待配送",@"订单待确认收货",@"订单已完成"];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:array];
        //设置间隔线颜色
        [segmentedControl setDividerImage:[UIImage imageNamed:@"icon_unSelectLine"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [segmentedControl setDividerImage:[UIImage imageNamed:@"icon_selectLine"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [segmentedControl setDividerImage:[UIImage imageNamed:@"icon_selectLine"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        segmentedControl.tintColor = [UIColor whiteColor];
        segmentedControl.backgroundColor = [UIColor whiteColor];
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : kSDYColorGreen} forState:UIControlStateSelected];
        
        [segmentedControl addTarget:self action:@selector(segmentedControlClickChangeOrderListWithStatus:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl = segmentedControl;
    }
    return _segmentedControl;
}


- (UITableView *)defaultTalbleView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor grayColor];
    return tableView;
}

- (NSMutableArray *)orderListDataSource
{
    if (!_orderListDataSource) {
        _orderListDataSource =  [NSMutableArray array];
    }
    return _orderListDataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
