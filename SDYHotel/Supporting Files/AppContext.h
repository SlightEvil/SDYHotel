//
//  AppContext.h
//  SDYHotel
//
//  Created by admin on 2017/12/11.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDYTitleView.h"
#import "NetWorkServices.h"
#import "LoginUser.h"
#import "ViewModel.h"



#define APPCT [AppContext sharedAppContext]

@class TabbarViewConModel;
@class ProductDetailModel;


@interface AppContext : NSObject
single_interface(AppContext)

@property (nonatomic) NSArray <TabbarViewConModel *>*viewConModelArray;

@property (nonatomic) NSArray *viewConAry;

/**
 top title View  设置值 title（标题）  account（账户）  balance（余额）
 */
@property (nonatomic) SDYTitleView *titleView;
//网络请求
@property (nonatomic) NetWorkServices *netWorkService;
//登录用户
@property (nonatomic) LoginUser *loginUser;
@property (nonatomic) BOOL isLogin;
//产品数组
@property (nonatomic) ViewModel *viewModel;
//产品详情  里面包含多个product detail 的model
@property (nonatomic) ProductDetailModel *productDetailModel;





/**
显示加载
 */
- (void)showActivity;

/**
 隐藏加载
 */
- (void)hiddenActivity;

/**
 显示表头
 */
- (void)showTitleView;

/**
 进入登录界面
 */
- (void)showLoginViewCon;

/**
 隐藏显示状态栏

 @param hidden hidden
 */
- (void)statusBarHidden:(BOOL)hidden;





@end
