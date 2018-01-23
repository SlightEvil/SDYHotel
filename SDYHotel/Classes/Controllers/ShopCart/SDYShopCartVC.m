//
//  SDYShopCartVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/29.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYShopCartVC.h"


static NSString *const shopCartCellIdentifier = @"SDYShopCartVCshopCartCellIdentifier";
static NSString *const shopCartSectionHeaderIdentifier = @"SDYShopCartVCshopCartSectionHeaderIdentifier";


@interface SDYShopCartVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *shopCartTableView;

@property (nonatomic) NSMutableArray *dataSource;

@end



@implementation SDYShopCartShopModel

@end

@implementation SDYShopCartProductModel

@end

@implementation SDYShopCartVC

/*
 以商家分类（商家为section） 商家里面的商品为row

 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.shopCartTableView];
}






#pragma mark - Delegate

#pragma mark - UITableViewDelegate  购物车TalbeView

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCartCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"购物车测试";
    
    return cell;
}

#pragma mark - Event response 事件响应连



#pragma mark - private method  私有方法

//- (void)


#pragma mark - Getter and Setter

- (UITableView *)shopCartTableView
{
    if (!_shopCartTableView) {
        _shopCartTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _shopCartTableView.delegate = self;
        _shopCartTableView.dataSource = self;
    
        [_shopCartTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:shopCartCellIdentifier];
//        [_shopCartTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:shopCartSectionHeaderIdentifier];
    }
    return _shopCartTableView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
