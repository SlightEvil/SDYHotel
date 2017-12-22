//
//  AppContext.m
//  SDYHotel
//
//  Created by admin on 2017/12/11.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "AppContext.h"
#import "TabbarViewConModel.h"
#import <AFNetworking.h>
#import "Masonry.h"
#import "SDYBaseVC.h"


@interface AppContext ()

@property (nonatomic) UIWindow *topWindow;

@property (nonatomic) UIActivityIndicatorView *activity;




@end

@implementation AppContext
single_implementation(AppContext)



#pragma mark - Private methods

- (void)showTitleView
{
    [self.topWindow makeKeyAndVisible];
}

- (void)showLoginViewCon
{
    SDYBaseVC*viewCon = [NSClassFromString(@"SDYLoginVC") new];
   [[self topViewController] presentViewController:viewCon animated:YES completion:nil];
}

- (void)statusBarHidden:(BOOL)hidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
}

- (void)showActivity
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.activity];
    self.activity.center = [UIApplication sharedApplication].keyWindow.center;
    [self.activity startAnimating];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)hiddenActivity
{
    [self.activity stopAnimating];
    [self.activity removeFromSuperview];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}




- (UIViewController *)topViewController
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *parent = rootVC;
    
    while ((parent = rootVC.presentedViewController) != nil ) {
        rootVC = parent;
    }
    
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    return rootVC;
}


#pragma mark - Getter and Setter

- (UIWindow *)topWindow
{
    if (!_topWindow) {
        _topWindow = [[UIWindow alloc] initWithFrame:CGRectZero];
        _topWindow.backgroundColor = SDYTitleViewColor;
        [_topWindow addSubview:self.titleView];
        _topWindow.frame = CGRectMake(0, 20, kScreenWidth, 44);
        _topWindow.rootViewController = [UIViewController new];
    
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(_topWindow);
        }];
    }
    return _topWindow;
}

- (SDYTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[SDYTitleView alloc] init];
    }
    return _titleView;
}

- (NSArray<TabbarViewConModel *> *)viewConModelArray {
    if (!_viewConModelArray) {
        _viewConModelArray = [NSMutableArray array];
        
        NSArray *dataAry = @[
  @{@"title":@"首页",@"imageName":@"gift",@"selectImageName":@"gift",@"classString":@"SDYHomeVC"},
  @{@"title":@"商品库",@"imageName":@"gift",@"selectImageName":@"gift",@"classString":@"SDYCommodityLibraryVC"},
  @{@"title":@"收藏记录",@"imageName":@"gift",@"selectImageName":@"gift",@"classString":@"SDYRecordVC"},
  @{@"title":@"我的订单",@"imageName":@"gift",@"selectImageName":@"gift",@"classString":@"SDYMyOrderVC"},
//  @{@"title":@"财务中心",@"imageName":@"gift",@"selectImageName":@"gift",@"classString":@"SDYMoneyCenterVC"},
  @{@"title":@"个人中心",@"imageName":@"gift",@"selectImageName":@"gift",@"classString":@"SDYPersonalCenterVC"}
  ];
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in dataAry) {
            TabbarViewConModel *viewConModel = [TabbarViewConModel classWithDic:dic];
            [array addObject:viewConModel];
        }
        
        _viewConModelArray = array.copy;
    }
    return _viewConModelArray;
}


- (NetWorkServices *)netWorkService
{
    if (!_netWorkService) {
        _netWorkService = [[NetWorkServices alloc]init];
    }
    return _netWorkService;
}

- (ViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[ViewModel alloc]init];
    }
    return _viewModel;
}

- (UIActivityIndicatorView *)activity
{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.hidesWhenStopped = YES;
    }
    return _activity;
}

@end
