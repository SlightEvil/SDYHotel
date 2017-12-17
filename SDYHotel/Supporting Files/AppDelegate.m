//
//  AppDelegate.m
//  SDYHotel
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "AppDelegate.h"
#import "TabbarViewConModel.h"
#import "SDYBaseNavigationVC.h"
#import "SDYBaseVC.h"
#import "AppContext.h"

//#import "SDYHomeVC.h"
//#import "SDYCommodityLibraryVC.h"
//#import "SDYRecordVC.h"
//#import "SDYMyOrderVC.h"
//#import "SDYMoneyCenterVC.h"
//#import "SDYPersonalCenterVC.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
 
    [self setTabbarConVC];
//    [[AppContext sharedAppContext] showTitleView];
    
    [AppContext sharedAppContext].isLogin = NO;
    


    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskLandscapeRight;
}


- (void)setTabbarConVC
{
    UITabBarController *tabbarCon = [[UITabBarController alloc] init];
    tabbarCon.tabBar.barTintColor = kUIColorFromRGB(0xf8f8f8);
    tabbarCon.tabBar.tintColor = kUIColorFromRGB(0x06ce8a);
    tabbarCon.tabBar.translucent = NO;
    
#pragma mark - 使用NAV
    NSMutableArray *navRootAry = [NSMutableArray array];
    for (TabbarViewConModel *model in [AppContext sharedAppContext].viewConModelArray) {
        SDYBaseNavigationVC *nav = [self rootNavigationViewConWithModel:model];
        [navRootAry addObject:nav];
    }
    [AppContext sharedAppContext].viewConAry = navRootAry;
#pragma mark - 使用ViewCon
//    NSMutableArray *vcRootAry = [NSMutableArray array];
//    for (TabbarViewConModel *model in [AppContext sharedAppContext].viewConModelArray) {
//        SDYBaseVC *VC = [self rootViewConWithModel:model];
//        [vcRootAry addObject:VC];
//    }
//    [AppContext sharedAppContext].viewConAry = vcRootAry;
    
    tabbarCon.viewControllers = [AppContext sharedAppContext].viewConAry;
    
    self.window.rootViewController = tabbarCon;
    [self.window makeKeyAndVisible];
}

- (SDYBaseVC *)rootViewConWithModel:(TabbarViewConModel *)model
{
    SDYBaseVC *vc = [NSClassFromString(model.classString) new];
    vc.tabBarItem.title = model.title;
    vc.tabBarItem.image = [UIImage imageNamed:model.imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:model.selectImageName];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : kUIColorFromRGB(0x06ce8a)} forState:UIControlStateSelected];
    return vc;
}

- (SDYBaseNavigationVC *)rootNavigationViewConWithModel:(TabbarViewConModel *)model
{
    
    SDYBaseVC *vc = [NSClassFromString(model.classString) new];
    vc.tabBarItem.title = model.title;
    vc.tabBarItem.image = [UIImage imageNamed:model.imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:model.selectImageName];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : kUIColorFromRGB(0x06ce8a)} forState:UIControlStateSelected];
    
    return [[SDYBaseNavigationVC alloc] initWithRootViewController:vc];
}


@end
