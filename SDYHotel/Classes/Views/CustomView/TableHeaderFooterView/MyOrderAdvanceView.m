//
//  MyOrderAdvanceView.m
//  SDYHotel
//
//  Created by admin on 2018/1/4.
//  Copyright © 2018年 SanDaoYi. All rights reserved.
//

#import "MyOrderAdvanceView.h"
#import "Function.h"
#import "MyOrderOrderListModel.h"
#import "MyOrderListOrderCell.h"
#import "UILabel+Category.h"


static NSString *const MyOrderListOrderCellIdentifier = @"MyOrderListOrderAdvanceOrPostCellIdentifier";


@interface MyOrderAdvanceView ()<UITableViewDelegate,UITableViewDataSource>

/** 显示商品的tableview */
@property (nonatomic) UITableView *tableView;
/** 订单总价 */
@property (nonatomic) UILabel *totalPriceLable;
/** 订单编号 */
@property (nonatomic) UILabel *orderNoLabel;
/** 订单状态 */
@property (nonatomic) UILabel *orderStatusLabel;
/** 创建时间 */
@property (nonatomic) UILabel *createAtLabel;
/** 备注 remark */
@property (nonatomic) UITextView *contentTextView;

/** 确认收获callback */
@property (nonatomic, copy) void(^compleBtnClick)(void);
/** 包含确认收货 */
@property (nonatomic, assign) BOOL containComple;
/** 确认收货 */
@property (nonatomic) UIButton *compleButton;


@end

@implementation MyOrderAdvanceView
{
    CGFloat _width;
    CGFloat _height;
}

- (instancetype)initWithAdvanceFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithPostFrame:(CGRect)frame compleBlock:(void (^)(void))block
{
    if (self = [super initWithFrame:frame]) {
        self.compleBtnClick = block;
        self.containComple = YES;
        [self setupUI];
    }
    return self;
}

#pragma mark - Event response

- (void)compleButtonClick:(UIButton *)sender
{
   
    NSString *orderID = self.listModel.order_id;

    [APPCT.netWorkService GET:kAPIURLUpdateOrderStatus parameters:@{@"id":orderID,@"status":@"3"} success:^(NSDictionary *dictionary) {
        
        NSInteger *requestStatus = [dictionary[status] integerValue];
        
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return;
        }
        [SVProgressHUD showSuccessWithStatus:@"更新success 请刷新左边订单列表"];
        [SVProgressHUD dismissWithDelay:1.0];
    
    } faile:^(NSString *errorDescription) {
        [SVProgressHUD showErrorWithStatus:errorDescription];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}

#pragma mark - Delegate  列表的代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 49;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  self.containComple ? self.listModel.post_details.count : self.listModel.details.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderListOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderListOrderCellIdentifier forIndexPath:indexPath];

    cell.orderDetailModel = self.containComple ? self.listModel.post_details[indexPath.row] : self.listModel.details[indexPath.row];
    return cell;
}



#pragma mark - Priavate method

- (void)setupUI
{
    _width = self.bounds.size.width;
    _height = self.bounds.size.height;
    
    [self setupHeaderView];
    [self setupFooterView];
    [self addSubview:self.tableView];
}

/** 设置表头 */
- (void)setupHeaderView
{
    NSString *title = self.containComple ? @"配送单" :@"预订单";
    self.tableView.tableHeaderView = [self tableViewHeaderLabelText:title size:CGSizeMake(_width, 80)];
}

/** 设置表尾 */
- (void)setupFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
    
    CGSize size = [Function sizeWithTitle:@"订单总价： " font:kCellFont];
    CGFloat labelHeight = 35;
    CGFloat space = 5;
    
    UILabel *totalPrice = [self labelWithTitle:@"订单总价:" Frame:CGRectMake(space, 0, size.width, labelHeight)];
    self.totalPriceLable = [self labelWithFrame:CGRectMake(CGRectGetMaxX(totalPrice.frame), 0,(_width - CGRectGetWidth(totalPrice.bounds)-space), labelHeight)];
    
    UILabel *orderNo = [self labelWithTitle:@"订单编号:" Frame:CGRectMake(space,CGRectGetMaxY(totalPrice.frame),size.width,labelHeight)];
    self.orderNoLabel = [self labelWithFrame:CGRectMake(CGRectGetMaxX(orderNo.frame), CGRectGetMinY(orderNo.frame), (_width - CGRectGetWidth(orderNo.bounds)-space), labelHeight)];
    
    UILabel *status = [self labelWithTitle:@"订单状态:" Frame:CGRectMake(space, CGRectGetMaxY(orderNo.frame), size.width, labelHeight)];
    self.orderStatusLabel = [self labelWithFrame:CGRectMake(CGRectGetMaxX(status.frame), CGRectGetMinY(status.frame), (_width - CGRectGetWidth(status.bounds)-space), labelHeight)];
    
    UILabel *createAt = [self labelWithTitle:@"下单时间:" Frame:CGRectMake(space,CGRectGetMaxY(status.frame),size.width,labelHeight)];
    self.createAtLabel = [self labelWithFrame:CGRectMake(CGRectGetMaxX(createAt.frame), CGRectGetMinY(createAt.frame), (_width - CGRectGetWidth(createAt.bounds)-space), labelHeight)];
    
    UILabel *content = [self labelWithTitle:@"备注:" Frame:CGRectMake(space,CGRectGetMaxY(createAt.frame),size.width,labelHeight)];
    self.contentTextView.frame = CGRectMake(space, CGRectGetMaxY(content.frame), _width-10, labelHeight*2);
    
    [footerView addSubview:totalPrice];
    [footerView addSubview:self.totalPriceLable];
    [footerView addSubview:orderNo];
    [footerView addSubview:self.orderNoLabel];
    [footerView addSubview:status];
    [footerView addSubview:self.orderStatusLabel];
    [footerView addSubview:createAt];
    [footerView addSubview:self.createAtLabel];
    [footerView addSubview:content];
    [footerView addSubview:self.contentTextView];
    
    if (self.containComple) {
        self.compleButton.frame = CGRectMake(20, CGRectGetMaxY(self.contentTextView.frame)+10, 150, 40);
        self.compleButton.hidden = YES;
        [footerView addSubview:self.compleButton];
        
        CGRect frame = footerView.frame;
        frame.size.height = CGRectGetMaxY(self.compleButton.frame)+40;
        footerView.frame = frame;
        
    } else {
        
        CGRect frame = footerView.frame;
        frame.size.height = CGRectGetMaxY(self.contentTextView.frame)+40;
        footerView.frame = frame;
    }
    
    self.tableView.tableFooterView = footerView;
}

- (UILabel *)labelWithTitle:(NSString *)title Frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:kCellFont];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = title;
    return label;
}

- (UILabel *)labelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:kCellFont];
    label.textAlignment = NSTextAlignmentRight;
    label.numberOfLines = 2;
    return label;
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
    
    NSArray *array = @[@"商品名称",@"单价 * 数量",@"小计"];
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

/**
 根据状态码返回状态描述

 @param status 状态码
 @return 状态描述
 */
- (NSString *)statusDetailWithNumber:(NSString *)status
{
    switch ([status integerValue]) {
        case 0:
        {
            self.compleButton.hidden = YES;
            return @"订单已提交";
        }
            break;
        case 1:
        {
            self.compleButton.hidden = NO;
            return @"订单待配送";
        }
            break;
        case 2:
        {
            self.compleButton.hidden = NO;
            return @"订单待确认收货";
        }
            break;
        case 3:
        {
            self.compleButton.hidden = YES;
            return @"订单已完成";
        }
            break;
            
        default:
        {
            self.compleButton.hidden = YES;
            return @"未知";
        }
            break;
    }
}
/** 清理数据 */
- (void)clearMessage
{
    self.totalPriceLable.text = @"";
    self.orderNoLabel.text = @"";
    self.orderStatusLabel.text = @"";
    self.createAtLabel.text = @"";
    self.contentTextView.text = @"";
    self.compleButton.hidden = YES;
    [self.tableView setContentOffset:CGPointZero animated:YES];
}


#pragma mark - Getter and Setter

- (void)setListModel:(MyOrderOrderListModel *)listModel
{
    _listModel = listModel;
    
    [self clearMessage];
    
    [self.tableView reloadData];

    if (self.containComple) {
        if (_listModel.post_details.count > 0) {
            
            self.totalPriceLable.text = _listModel.price;
            self.orderNoLabel.text = _listModel.order_no;
            self.orderStatusLabel.text = [self statusDetailWithNumber:_listModel.status];
            self.createAtLabel.text = _listModel.created_at;
            self.contentTextView.text = _listModel.content;
        }
    } else {
        
        self.totalPriceLable.text = _listModel.price;
        self.orderNoLabel.text = _listModel.order_no;
        self.orderStatusLabel.text = [self statusDetailWithNumber:_listModel.status];
        self.createAtLabel.text = _listModel.created_at;
        self.contentTextView.text = _listModel.content;
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView  registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderListOrderCell class]) bundle:nil] forCellReuseIdentifier:MyOrderListOrderCellIdentifier];
    }
    return _tableView;
}

- (UIButton *)compleButton
{
    if (!_compleButton) {
        _compleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_compleButton setTitle:@"确认收货" forState:UIControlStateNormal];
        [_compleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_compleButton addTarget:self action:@selector(compleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _compleButton.layer.masksToBounds = YES;
        _compleButton.layer.borderWidth = 0.75;
        _compleButton.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _compleButton;
}
- (UITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.textColor = [UIColor grayColor];
        _contentTextView.editable = NO;
        _contentTextView.selectable = NO;
        _contentTextView.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _contentTextView;
}

@end
