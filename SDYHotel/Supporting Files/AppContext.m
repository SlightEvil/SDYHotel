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

@end

@implementation AppContext
single_implementation(AppContext)



#pragma mark - Private methods

- (void)showTitleView
{
    [self.topWindow makeKeyAndVisible];
}
#pragma mark - 登录
- (void)showLoginViewCon
{
    SDYBaseVC*viewCon = [NSClassFromString(@"SDYLoginVC") new];
   [[self topViewController] presentViewController:viewCon animated:YES completion:nil];
}

- (void)statusBarHidden:(BOOL)hidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
}


#pragma mark - NSUserDefaults
- (void)userDefaultSave:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (id)userDefaultVlaueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
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


/** 替换 Null 为 “” */
- (NSData *)jsonReplaceNull:(NSData *)data
{
    NSString *jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    jsonString =  [jsonString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}


#pragma mark - Getter and Setter

- (UIWindow *)topWindow
{
    if (!_topWindow) {
        _topWindow = [[UIWindow alloc] initWithFrame:CGRectZero];
        _topWindow.backgroundColor = kSDYTitleViewColor;
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
  @{@"title":@"首页",@"imageName":@"tabbar_home",@"selectImageName":@"tabbar_home",@"classString":@"SDYHomeVC"},
  @{@"title":@"商品库",@"imageName":@"tabbar_library",@"selectImageName":@"gift",@"classString":@"SDYCommodityLibraryVC"},
  @{@"title":@"收藏记录",@"imageName":@"tabbar_record",@"selectImageName":@"tabbar_record",@"classString":@"SDYRecordVC"},
  @{@"title":@"我的订单",@"imageName":@"tabbar_myorder",@"selectImageName":@"tabbar_myorder",@"classString":@"SDYMyOrderVC"},
//  @{@"title":@"财务中心",@"imageName":@"gift",@"selectImageName":@"gift",@"classString":@"SDYMoneyCenterVC"},
  @{@"title":@"个人中心",@"imageName":@"tabbar_account",@"selectImageName":@"tabbar_account",@"classString":@"SDYPersonalCenterVC"}
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

@end
