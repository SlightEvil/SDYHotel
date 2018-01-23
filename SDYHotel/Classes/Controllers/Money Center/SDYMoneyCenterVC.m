//
//  SDYMoneyCenterVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYMoneyCenterVC.h"
#import "Masonry.h"
#import <MJRefresh/MJRefresh.h>
#import "AccountMoneyModel.h"
#import "SDYAccountCell.h"


static NSString *const cellIdentifier = @"SDYMoneyCenterVCTableViewCellIdentifier";

@interface SDYMoneyCenterVC ()<UITableViewDelegate,UITableViewDataSource>


/** 显示交易流水的表 */
@property (nonatomic) UITableView *accountTableView;

/** 账户 */
@property (nonatomic) UILabel *accountLabel;
/** 余额 */
@property (nonatomic) UILabel *balanceLabel;
/** 可用余额 */
@property (nonatomic) UILabel *validBalanceLabel;
/** 冻结基金 */
@property (nonatomic) UILabel *frozenFundLabel;
/** 可提现基金 */
@property (nonatomic) UILabel *cashFundLabel;

/** 账户预览 里面没有明细 需要从另一个交易明细接口那明细 */
@property (nonatomic) AccountMoneyModel *accountMoneyModel;
/** 交易流水数据 */
@property (nonatomic) NSArray *dealFlowAry;

@end

@implementation SDYMoneyCenterVC
{
    NSUInteger _currentPageNumber;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"财务中心";
    
    [self setupUI];
    [self layoutWithAuto];
    [self setupHeaderFooterRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!APPCT.isLogin) {
        [APPCT showLoginViewCon];
        return;
    }
    
    [self requestAccountMoneyShow];
    [self requestAccountLogPageNumber:@"1" pageLine:@"20"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    sdy_asyncDispatchToMainQueue(^{
        [self.accountTableView.mj_header endRefreshing];
        [self.accountTableView.mj_footer endRefreshing];
    });
}


#pragma mark - Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat width = kScreenWidth - 200;
    CGFloat typeLabelWidth = 90;
    CGFloat labelHeight = 50;
    CGFloat OrderLabelWidth = (width - typeLabelWidth*3)/2;
    
    NSArray *titleAry = @[@"交易类型",@"订单号",@"交易时间",@"金额",@"余额"];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
   
    UILabel *typeLabel = [self setupSectionLabelWithTitle:titleAry[0] frame:CGRectMake(0, 0, typeLabelWidth, labelHeight)];
    UILabel *orderNoLabel = [self setupSectionLabelWithTitle:titleAry[1] frame:CGRectMake(CGRectGetMaxX(typeLabel.frame), 0, OrderLabelWidth, labelHeight)];
    UILabel *timeLabel = [self setupSectionLabelWithTitle:titleAry[2] frame:CGRectMake(CGRectGetMaxX(orderNoLabel.frame), 0, OrderLabelWidth, labelHeight)];
    UILabel *moneyLabel = [self setupSectionLabelWithTitle:titleAry[3] frame:CGRectMake(CGRectGetMaxX(timeLabel.frame), 0, typeLabelWidth, labelHeight)];
    UILabel *balanceLabel = [self setupSectionLabelWithTitle:titleAry[4] frame:CGRectMake(CGRectGetMaxX(moneyLabel.frame), 0, typeLabelWidth, labelHeight)];
    
    [headerView addSubview:typeLabel];
    [headerView addSubview:orderNoLabel];
    [headerView addSubview:timeLabel];
    [headerView addSubview:moneyLabel];
    [headerView addSubview:balanceLabel];
    
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dealFlowAry ? self.dealFlowAry.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDYAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.accountLogModel = self.dealFlowAry[indexPath.row];
    
    return cell;
}

#pragma mark - Event response
/** 下拉刷新 */
- (void)mjRefreshHeaderAction
{
    [self requestAccountMoneyShow];
}
/** 下拉加载 */
- (void)mjRefreshFooterAction
{
    [self requestAccountLogPageNumber:[NSString stringWithFormat:@"%zd",(_currentPageNumber+1)] pageLine:@"20"];
}

#pragma mark - Private method
/** 设置UI */
- (void)setupUI
{
    [self.view addSubview:self.accountTableView];
    [self.view addSubview:self.accountLabel];
    [self.view addSubview:self.balanceLabel];
    [self.view addSubview:self.validBalanceLabel];
    [self.view addSubview:self.frozenFundLabel];
    [self.view addSubview:self.cashFundLabel];
}
/** 使用自动布局 */
- (void)layoutWithAuto
{
    [self.accountTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.right.equalTo(self.view).mas_offset(-200);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.view);
        make.left.equalTo(self.accountTableView.mas_right).mas_offset(1);
        make.height.mas_equalTo(50);
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountLabel);
        make.top.equalTo(self.accountLabel.mas_bottom).mas_offset(1);
    }];
    [self.validBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.balanceLabel);
        make.top.equalTo(self.balanceLabel.mas_bottom).mas_offset(1);
    }];
    [self.frozenFundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.validBalanceLabel);
        make.top.equalTo(self.validBalanceLabel.mas_bottom).mas_offset(1);
    }];
    [self.cashFundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.frozenFundLabel);
        make.top.equalTo(self.frozenFundLabel.mas_bottom).mas_offset(1);
    }];
}
/** 设置下拉刷新，上拉加载 */
- (void)setupHeaderFooterRefresh
{
    MJRefreshGifHeader *gitHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(mjRefreshHeaderAction)];
    
    NSArray *idleImageAry = [self IdleImageArray];
    NSArray *pullRefreshImageAry = [self PullRefreshingImageAry];
    
    [gitHeader setImages:idleImageAry forState:MJRefreshStateIdle];
    [gitHeader setImages:pullRefreshImageAry forState:MJRefreshStatePulling];
    [gitHeader setImages:pullRefreshImageAry forState:MJRefreshStateRefreshing];
    self.accountTableView.mj_header = gitHeader;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjRefreshFooterAction)];
    self.accountTableView.mj_footer = footer;
}

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



#pragma mark - 网络请求

/** 请求账户信息 */
- (void)requestAccountMoneyShow
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    _currentPageNumber = 1;
    
    [APPCT.netWorkService GET:kAPIURLAccountMoney parameters:@{} success:^(NSDictionary *dictionary) {
        NSUInteger requestState = [dictionary[status] integerValue];
        if (requestState != 0) {
            sdy_asyncDispatchToMainQueue(^{
                [strongSelf.accountTableView.mj_header endRefreshing];
                [strongSelf.accountTableView.mj_footer endRefreshing];
            });
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
     
            return ;
        }
        /** 使用setter 进行数据更新操作 */
        strongSelf.accountMoneyModel = [AccountMoneyModel cz_objWithDict:dictionary[@"data"]];
        sdy_asyncDispatchToMainQueue(^{
            [strongSelf.accountTableView.mj_header endRefreshing];
            [strongSelf.accountTableView.mj_footer endRefreshing];
        });
        
    } faile:^(NSString *errorDescription) {
        sdy_asyncDispatchToMainQueue(^{
            [strongSelf.accountTableView.mj_header endRefreshing];
            [strongSelf.accountTableView.mj_footer endRefreshing];
        });
        [SVProgressHUD showErrorWithStatus:errorDescription];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}
/** 请求账户流水 */
- (void)requestAccountLogPageNumber:(NSString *)pageNumber pageLine:(NSString *)pageLine
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    _currentPageNumber = [pageNumber integerValue];
    
    [APPCT.netWorkService GET:kAPIURLAccountLog parameters:@{@"p":pageNumber,@"len":pageLine} success:^(NSDictionary *dictionary) {
        
        NSUInteger  requestStatu = [dictionary[status] integerValue];
        if (requestStatu != 0) {
            sdy_asyncDispatchToMainQueue(^{
                [strongSelf.accountTableView.mj_header endRefreshing];
                [strongSelf.accountTableView.mj_footer endRefreshing];
            });
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return;
        }
        
        NSArray *dataAry = dictionary[@"data"];
        NSMutableArray *array = [NSMutableArray array];
        [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AccountLogModel *logModel = [AccountLogModel cz_objWithDict:obj];
            [array addObject:logModel];
        }];
    
        if ([pageNumber isEqualToString:@"1"]) {
            strongSelf.dealFlowAry = array;
        } else {
            
            NSMutableArray *array2 = strongSelf.dealFlowAry.mutableCopy;
            [array2 addObjectsFromArray:array];
            strongSelf.dealFlowAry  = array2;
        }
        sdy_asyncDispatchToMainQueue(^{
            [strongSelf.accountTableView.mj_header endRefreshing];
            [strongSelf.accountTableView.mj_footer endRefreshing];
        });
        
    } faile:^(NSString *errorDescription) {
        sdy_asyncDispatchToMainQueue(^{
            [strongSelf.accountTableView.mj_header endRefreshing];
            [strongSelf.accountTableView.mj_footer endRefreshing];
        });
        [SVProgressHUD showErrorWithStatus:errorDescription];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}


- (UILabel *)setupDefaultLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:kCellFont];
    return label;
}
/** 表 section label设置 */
- (UILabel *)setupSectionLabelWithTitle:(NSString *)title frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:kCellFont];
    label.numberOfLines = 2;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

#pragma mark - Getter and Setter

- (void)setAccountMoneyModel:(AccountMoneyModel *)accountMoneyModel
{
    _accountMoneyModel = accountMoneyModel;
    
    AccountModel *accountModel = _accountMoneyModel.account[AccountKey];
    self.balanceLabel.text = [NSString stringWithFormat:@"余额:%@",accountModel.balance];
    self.validBalanceLabel.text = [NSString stringWithFormat:@"可用余额:%@",accountModel.valid_balance];
    self.frozenFundLabel.text = [NSString stringWithFormat:@"冻结金额:%@",accountModel.frozen_fund];
    self.cashFundLabel.text = [NSString stringWithFormat:@"可提现金额:%@",accountModel.cash_fund];
}

- (void)setDealFlowAry:(NSArray *)dealFlowAry
{
    _dealFlowAry = dealFlowAry;
    [self.accountTableView reloadData];
}


- (UITableView *)accountTableView
{
    if (!_accountTableView) {
        _accountTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _accountTableView.delegate = self;
        _accountTableView.dataSource = self;
        
        [_accountTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SDYAccountCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    }
    return _accountTableView;
}

- (UILabel *)accountLabel
{
    if (!_accountLabel) {
        _accountLabel = [self setupDefaultLabel];
        _accountLabel.text = @"账户资金";
    }
    return _accountLabel;
}

- (UILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [self setupDefaultLabel];
        _balanceLabel.textColor = [UIColor redColor];
        _balanceLabel.text = @"余额:0";
    }
    return _balanceLabel;
}

- (UILabel *)validBalanceLabel
{
    if (!_validBalanceLabel) {
        _validBalanceLabel = [self setupDefaultLabel];
        _validBalanceLabel.text = @"可用余额:0";
    }
    return _validBalanceLabel;
}

- (UILabel *)frozenFundLabel
{
    if (!_frozenFundLabel) {
        _frozenFundLabel = [self setupDefaultLabel];
        _frozenFundLabel.text = @"冻结金额:0";
    }
    return _frozenFundLabel;
}
- (UILabel *)cashFundLabel
{
    if (!_cashFundLabel) {
        _cashFundLabel = [self setupDefaultLabel];
        _cashFundLabel.text = @"可提现金额:0";
    }
    return _cashFundLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
