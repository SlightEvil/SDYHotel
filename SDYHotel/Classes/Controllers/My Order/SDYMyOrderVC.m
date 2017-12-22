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

#import "MyOrderOrderListModel.h"

#import "MyOrderTableViewSectionView.h"
#import "MyOrderOrderListFooterView.h"
#import "MyOrderListOrderCell.h"


static NSString *const MyOrderOrderListCellIdentifier = @"MyOrderOrderListCellIdentifier";
static NSString *const MyOrderAdvanceOrderCellIdentifier = @"MyOrdreAdvanceOrderCellIdentifier";
static NSString *const MyOrderPostOrderCellIdentifier = @"MyOrderPostOrderCellIdentifier";
static NSString *const MyOrderAdvanceOrderSectionIdentifier = @"MyOrderAdvanceOrderSectionIdentifier";
static NSString *const MyOrderPostOrderSectionIdentifier = @"MyOrderPostOrderSectionIdentifier";

static NSString *const MyOrderAdvanceOrderFooterIdentifier = @"MyOrderAdvanceOrderFooterIdentifier";
static NSString *const MyOrderPostOrderFooterIdentifier = @"MyOrderPostOrderFooterIdentifier";



@interface SDYMyOrderVC ()<UITableViewDelegate,UITableViewDataSource>

/**
 订单列表
 */
@property (nonatomic) UITableView *orderListTableView;
/**
 预订单
 */
@property (nonatomic) UITableView *advanceOrderTableView;
/**
 配送单
 */
@property (nonatomic) UITableView *postOrderTableView;

/**
 订单列表
 */
@property (nonatomic) NSMutableArray *orderListDataSource;

/**
 配送单列表
 */
@property (nonatomic) NSMutableArray *postOrderDataSource;

/**
 订单列表  选择日期 的row
 */
@property (nonatomic) NSInteger orderListSelectRow;


/**
 获取今天的日期
 */
@property (nonatomic) NSString *today;
/**
 昨天的日期
 */
@property (nonatomic) NSString *yestoday;
//日期格式化
@property (nonatomic) NSDateFormatter *dateFormatter;



@end

@implementation SDYMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = [UIColor grayColor];
// kUIColorFromRGB(0x454139) textColor
//kUIColorFromRGB(0xabada5)  分割线color
    [self.view addSubview:self.orderListTableView];
    [self.view addSubview:self.advanceOrderTableView];
    [self.view addSubview:self.postOrderTableView];
    
    [self layoutWithAuto];
    
    //获取当前时间
    self.today = [self.dateFormatter stringFromDate:[NSDate date]];
    //获取昨天的日期
    self.yestoday = [self.dateFormatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:-60*60*24]];
    


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [APPCT.netWorkService GET:kSDYNetWorkOrderListUrl parameters:@{page:@"1",line:@"1000",@"status":@""} success:^(NSDictionary *data, NSString *errorDescription) {
            
            NSInteger requestStetus = [data[status] integerValue];
            NSString *backMessage = data[message];
            
            if (requestStetus != 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf alertTitle:backMessage message:nil complete:nil];
                });
            }
            
            NSArray *dataAry = data[@"data"];
            NSMutableArray *array = [NSMutableArray array];
            NSMutableArray *arrayToday = [NSMutableArray array];
            NSMutableArray *arrayYestoday = [NSMutableArray array];
            [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                if ([dic[@"created_at"] hasPrefix:self.today]) {
                    
                    MyOrderOrderListModel *orderListModel = [MyOrderOrderListModel cz_objWithDict:dic];
                    [arrayToday addObject:orderListModel];
                    
                }
                if ([dic[@"created_at"] hasPrefix:self.yestoday]) {
                    MyOrderOrderListModel *orderListModel = [MyOrderOrderListModel cz_objWithDict:dic];
                    [arrayYestoday addObject:orderListModel];
                }
            }];
            
            [array addObject:arrayToday];
            [array addObject:arrayYestoday];
            strongSelf.orderListDataSource = array.copy;
            
#pragma mark - 根据今天昨天添加到数组里面
        
            [strongSelf.orderListTableView reloadData];
            [strongSelf.advanceOrderTableView reloadData];
            [strongSelf.postOrderTableView reloadData];
            
        } faile:^(NSString *errorDescription) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf alertTitle:errorDescription message:nil complete:nil];
            });
        }];
    });
}


#pragma mark - Delegate

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    根据cell的内容确定
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == tableViewTagMyOrderOrderList) {
        return 0;
    }
    if (tableView.tag == tableViewTagMyOrderAdvanceOrder) {
        return 49;
    }
    if (tableView.tag == tableViewTagMyOrderPostOrder) {
        return 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (tableView.tag == tableViewTagMyOrderOrderList) {
        return 0;
    }
    
    if (self.orderListDataSource.count > 0) {
        
        if (tableView.tag == tableViewTagMyOrderAdvanceOrder) {
            return 200;
        }
        if (tableView.tag == tableViewTagMyOrderPostOrder) {
            return self.postOrderDataSource.count * 200;
        }
    }

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == tableViewTagMyOrderAdvanceOrder) {
        MyOrderTableViewSectionView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MyOrderAdvanceOrderSectionIdentifier];
        
        if (self.orderListDataSource.count > 0) {
            NSArray *array = self.orderListDataSource[self.orderListSelectRow];
            MyOrderOrderListModel *listOrderModel = array[section];
            sectionView.sectionModel = listOrderModel;
            
            __weak typeof(self)weakSelf = self;
            
            sectionView.sectionClickBlock = ^(BOOL isExpanded) {
                weakSelf.postOrderDataSource = @[listOrderModel];
                [weakSelf.postOrderTableView reloadData];
            };
            
//            NSArray *postArray = @[listOrderModel];
//
//            self.postOrderDataSource = postArray.copy;
//
//            __weak typeof(self)weakSelf = self;
//            __strong typeof(weakSelf)strongSelf = weakSelf;
//
//            sectionView.sectionClickBlock = ^(BOOL isExpanded) {
//                [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:nil];
//                [strongSelf.postOrderTableView reloadData];
//
//
//            };
        }
        return sectionView;
    }
    if (tableView.tag == tableViewTagMyOrderPostOrder) {
        if (self.postOrderDataSource.count > 0) {
        
            MyOrderOrderListModel *model = self.postOrderDataSource[section];
            UILabel *label = [[UILabel alloc] init];
            label.text = model.shop_name;
            return label;
        }
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag == tableViewTagMyOrderAdvanceOrder) {
        MyOrderOrderListFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MyOrderAdvanceOrderFooterIdentifier];
        if (self.orderListDataSource.count > 0) {
            NSArray *array = self.orderListDataSource[self.orderListSelectRow];
            MyOrderOrderListModel *model = array[section];
            footView.footerModel = model;
        }
        footView.isPostOrder = NO;
        return footView;
    }
    
    if (tableView.tag == tableViewTagMyOrderPostOrder) {
        MyOrderOrderListFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MyOrderPostOrderFooterIdentifier];
        if (self.postOrderDataSource.count > 0) {
    
            MyOrderOrderListModel *model = self.postOrderDataSource[section];
            footView.footerModel = model;
        }
        footView.isPostOrder = YES;
        return footView;
    }
   
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == tableViewTagMyOrderOrderList) {
        self.orderListSelectRow = indexPath.row;
        
        [self.advanceOrderTableView reloadData];
        [self.advanceOrderTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
        [self.postOrderTableView reloadData];
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == tableViewTagMyOrderOrderList) {
        return 1;
    }
    
    if (tableView.tag == tableViewTagMyOrderPostOrder) {
        return self.postOrderDataSource.count;
    }
    if (tableView.tag == tableViewTagMyOrderAdvanceOrder) {
        
        if (self.orderListDataSource.count > 0) {
            NSArray *array = self.orderListDataSource[self.orderListSelectRow];
            return array.count;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == tableViewTagMyOrderOrderList) {
        return self.orderListDataSource.count;
    }
    if (tableView.tag == tableViewTagMyOrderPostOrder) {
        
        if (self.orderListDataSource.count > 0) {
            
            MyOrderOrderListModel *model = self.postOrderDataSource[0];
            return model.post_details.count;
        }
        
        return self.postOrderDataSource.count;
    }
    if (tableView.tag == tableViewTagMyOrderAdvanceOrder) {
        
        if (self.orderListDataSource.count > 0) {
            NSArray *array = self.orderListDataSource[self.orderListSelectRow];
            MyOrderOrderListModel *orderListModel = array[section];
            
         return orderListModel.details.count;
        }
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == tableViewTagMyOrderOrderList) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderOrderListCellIdentifier forIndexPath:indexPath];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
        if (indexPath.row == 0) {
            cell.textLabel.text = self.today;
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = self.yestoday;
        }
        return cell;
    }
    
    if (tableView.tag == tableViewTagMyOrderAdvanceOrder) {
        
        MyOrderListOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderAdvanceOrderCellIdentifier forIndexPath:indexPath];
    
        if (self.orderListDataSource.count > 0) {
            NSArray *array = self.orderListDataSource[self.orderListSelectRow];
            MyOrderOrderListModel *orderListModel = array[indexPath.section];
            MyOrderOrderDetailModel *detailModel = orderListModel.details[indexPath.row];
            cell.orderDetailModel = detailModel;
        
        }
         return cell;
    }
    
    if (tableView.tag == tableViewTagMyOrderPostOrder) {
        MyOrderListOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderPostOrderCellIdentifier forIndexPath:indexPath];
        
        if (self.postOrderDataSource.count >0) {
            
            MyOrderOrderListModel *model = self.postOrderDataSource[indexPath.section];
            
            if (model.post_details.count > 0) {
                cell.orderDetailModel = model.post_details[indexPath.row];
            }
            
            
        }

         return cell;
    }
   
    return nil;
}

#pragma mark - Event response





#pragma mark - Private method

- (void)layoutWithAuto
{
    [self.orderListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(200);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    [self.advanceOrderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.orderListTableView);
        make.left.equalTo(self.orderListTableView.mas_right).mas_offset(0.5);
    }];
    [self.postOrderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.advanceOrderTableView);
        make.left.equalTo(self.advanceOrderTableView.mas_right).mas_offset(0.5);
        make.right.equalTo(self.view);
        make.width.mas_equalTo(self.advanceOrderTableView.mas_width);
    }];
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
        label.frame = CGRectMake(0, 0, 200, 80);
        _orderListTableView.tableHeaderView = label;
        
        [_orderListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MyOrderOrderListCellIdentifier];
    }
    return _orderListTableView;
}

- (UITableView *)advanceOrderTableView
{
    if (!_advanceOrderTableView) {
        _advanceOrderTableView = [self defaultTalbleView];
        _advanceOrderTableView.tag = tableViewTagMyOrderAdvanceOrder;
        _advanceOrderTableView.tableHeaderView = [self tableViewHeaderLabelText:@"预订单" size:CGSizeMake((kScreenWidth - 200)/2,80)];
        [_advanceOrderTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderListOrderCell class]) bundle:nil] forCellReuseIdentifier:MyOrderAdvanceOrderCellIdentifier];
        
//        [_advanceOrderTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MyOrderAdvanceOrderCellIdentifier];
        [_advanceOrderTableView registerClass:[MyOrderTableViewSectionView class] forHeaderFooterViewReuseIdentifier:MyOrderAdvanceOrderSectionIdentifier];
        [_advanceOrderTableView registerClass:[MyOrderOrderListFooterView class] forHeaderFooterViewReuseIdentifier:MyOrderAdvanceOrderFooterIdentifier];
    }
    return _advanceOrderTableView;
}

- (UITableView *)postOrderTableView
{
    if (!_postOrderTableView) {
        _postOrderTableView = [self defaultTalbleView];
        _postOrderTableView.tag = tableViewTagMyOrderPostOrder;
        _postOrderTableView.tableHeaderView = [self tableViewHeaderLabelText:@"配送单" size:CGSizeMake((kScreenWidth - 200)/2,80)];
        
        [_postOrderTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderListOrderCell class]) bundle:nil] forCellReuseIdentifier:MyOrderPostOrderCellIdentifier];
        
//        [_postOrderTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MyOrderPostOrderCellIdentifier];
        [_postOrderTableView registerClass:[MyOrderTableViewSectionView class] forHeaderFooterViewReuseIdentifier:MyOrderPostOrderSectionIdentifier];
        [_postOrderTableView registerClass:[MyOrderOrderListFooterView class] forHeaderFooterViewReuseIdentifier:MyOrderPostOrderFooterIdentifier];
    }
    return _postOrderTableView;
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

/**
 表头

 @param title title
 @param size 宽度
 @return 表头
 */
- (UIView *)tableViewHeaderLabelText:(NSString *)title size:(CGSize)size
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLable = [UILabel labelWithTextColor:nil font:18];
    titleLable.text = title;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.frame = CGRectMake(0, 0, size.width, 40);
    [headerView addSubview:titleLable];
    
    NSArray *array = @[@"商品名称",@"数量 * 单价",@"小计"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UILabel *label = [self labelWithTitle:obj frame:CGRectMake((size.width/3) *idx, 40, (size.width/3), 40)];
        [headerView addSubview:label];
    }];
    
    return headerView;
}
//循环添加label
- (UILabel *)labelWithTitle:(NSString *)title frame:(CGRect)frame
{
    UILabel *label = [UILabel labelWithTextColor:kUIColorFromRGB(0xffa900) font:18];
    label.frame = frame;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


- (NSMutableArray *)orderListDataSource
{
    if (!_orderListDataSource) {
        _orderListDataSource =  [NSMutableArray array];
    }
    return _orderListDataSource;
}

- (NSMutableArray *)postOrderDataSource
{
    if (!_postOrderDataSource) {
        _postOrderDataSource = [NSMutableArray array];
    }
    return _postOrderDataSource;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
