//
//  SDYPersonalCenterVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYPersonalCenterVC.h"
#import "UIImage+Category.h"
#import "UILabel+Category.h"
#import "SDYPersonalCell.h"
#import "PersonalFooterView.h"
#import "SDYMoneyCenterVC.h"



static NSString *const personalCellIdentifier = @"SDYPersonalCenterVCCellIdentifier";
static NSString *const personalFirstCellIdentifier = @"SDYPersonalCenterVCpersonalFirstCellIdentifier";
static NSString *const personalFooterIdentifier = @"SDYPersonalCenterVCpersonalFooterIdentifier";

@interface SDYPersonalCenterVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic) UITableView *personalTableView;
/** 数据源 */
@property (nonatomic) NSMutableArray *dataSource;
/** 个人中心设置 */
@property (nonatomic) UIImageView *tableHeaderView;
/** 头像 */
@property (nonatomic) UIImageView *headProtraitImageView;
/** 登录 */
@property (nonatomic) UIButton *loginButton;
/** 登录之后显示用户名 */
@property (nonatomic) UILabel *userNameLabel;


@end

@implementation SDYPersonalCenterVC
{
    CGFloat _width;
    CGFloat _height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";

    _width = self.view.width;
    _height = self.view.height;
    
    [self.view addSubview:self.personalTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self isLoginSetupUI];
}


#pragma mark - Delegate   代理方法

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!APPCT.isLogin) {
        [APPCT showLoginViewCon];
        return;
    }

    if (indexPath.row == 0) [self cellMyMondyClick];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    PersonalFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:personalFooterIdentifier];
    footer.buttonClick = ^{
        [strongSelf registerLoginButtonClick];
    };
    
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:personalCellIdentifier forIndexPath:indexPath];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark - Event response  事件响应链

/** 登录 */
- (void)loginButtonClick
{
    [APPCT showLoginViewCon];
}

- (void)registerLoginButtonClick
{
    if (APPCT.isLogin) {
        [self alertTitle:@"确定退出登录？" message:nil complete:^{
            APPCT.isLogin = NO;
            APPCT.loginUser = [LoginUser new];
            [self isLoginSetupUI];
        }];
    }
}

/** 点击tableview 头部 图片 */
- (void)tableHeaderViewClick:(UITapGestureRecognizer *)gesture
{
    NSLog(@"图片view 互动");
}
/** 我的收藏 */
- (void)cellMyRecordClick
{
    self.tabBarController.selectedIndex = 2;
}

/** 财务中心 */
- (void)cellMyMondyClick
{
    SDYMoneyCenterVC *moneyVC = [[SDYMoneyCenterVC alloc] init];
    moneyVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:moneyVC animated:YES];
}

/** 我的订单 */
- (void)cellMyOrderClick
{
    self.tabBarController.selectedIndex = 3;
}

#pragma mark - Private method  私有方法

/** 根据登录状态设置 */
- (void)isLoginSetupUI
{
    if (APPCT.isLogin) {
        self.loginButton.hidden = YES;
        self.userNameLabel.hidden = NO;
        self.userNameLabel.text = APPCT.loginUser.user_name;
    } else {
        self.loginButton.hidden = NO;
        self.userNameLabel.hidden = YES;
    }
}

#pragma mark - Getter and Setter


- (UITableView *)personalTableView
{
    if (!_personalTableView) {
        _personalTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _personalTableView.delegate = self;
        _personalTableView.dataSource = self;
        
        _personalTableView.tableHeaderView = self.tableHeaderView;
        
        [_personalTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:personalCellIdentifier];
    
        [_personalTableView registerClass:[PersonalFooterView class] forHeaderFooterViewReuseIdentifier:personalFooterIdentifier];
        /*
        [_personalTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SDYPersonalCell class]) bundle:nil] forCellReuseIdentifier:personalFirstCellIdentifier];
         */
    }
    return _personalTableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithObjects:@"我的资金", nil];
    }
    return _dataSource;
}

- (UIImageView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _tableHeaderView.image = [UIImage sizeImageWithImage:[UIImage imageNamed:@"background"] sizs:CGSizeMake(kScreenWidth, 100)];
        //userInteractionEnabled 开启用户互动
        _tableHeaderView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableHeaderViewClick:)];
        [_tableHeaderView addGestureRecognizer:tap];
        
        CGRect frame = self.headProtraitImageView.frame;
        frame.origin = CGPointMake(kScreenWidth/2-100, 20);
        self.headProtraitImageView.frame = frame;
        [_tableHeaderView addSubview:self.headProtraitImageView];
        
        frame = self.loginButton.frame;
        frame.origin = CGPointMake(kScreenWidth/2, 40);
        self.loginButton.frame = frame;
        [_tableHeaderView addSubview:self.loginButton];
        
        self.userNameLabel.frame = self.loginButton.frame;
        [_tableHeaderView addSubview:self.userNameLabel];
        
    }
    return _tableHeaderView;
}

- (UIImageView *)headProtraitImageView
{
    if (!_headProtraitImageView) {
        _headProtraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _headProtraitImageView.layer.masksToBounds = YES;
        _headProtraitImageView.layer.cornerRadius = 10;
        _headProtraitImageView.image = [UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_account"] sizs:CGSizeMake(60, 60)];
    }
    return _headProtraitImageView;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _loginButton.frame = CGRectMake(0, 0, 200, 40);
    }
    return _loginButton;
}

- (UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:self.loginButton.frame];
        _userNameLabel.font = [UIFont systemFontOfSize:16];
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.hidden = YES;
    }
    return _userNameLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
