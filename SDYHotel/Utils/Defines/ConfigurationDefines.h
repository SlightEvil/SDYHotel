//
//  ConfigurationDefines.h
//  SDYHotel
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#ifndef ConfigurationDefines_h
#define ConfigurationDefines_h

#define kSDYImagePrefix             @"http://www.3daoyi.com"
#define kSDYImageUrl(imageUrlSuffix)       kStrAppendStr(kSDYImagePrefix,imageUrlSuffix)

//测试网络连接
#define kSDYNetWorkReachabilityUrl     @"http://api.origin.3daoyi.com/"
#define kSDYNetWorkBaiduUrl         @"https://www.baidu.com"

//三道易API前缀URL
#define kSDYApiPrefixUrl      @"http://api.origin.3daoyi.com/index.php?"

#pragma mark - POST

//酒店用户登录
#define kSDYNetWorkShopLoginUrl   kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=index&a=login")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=index&a=login"

//供应商用户登录
#define kSDYNetWorkProviderLoginUrl     kStrAppendStr(kSDYApiPrefixUrl,@"s=provider&m=index&a=login")
//@"http://api.origin.3daoyi.com/index.php?s=provider&m=index&a=login"

//供应商重置密码
#define kSDYNetWorkProviderREPSWUrl     kStrAppendStr(kSDYApiPrefixUrl,@"s=provider&m=index&a=repsw")
//@"http://api.origin.3daoyi.com/index.php?s=provider&m=index&a=repsw"

//供应商订单列表
#define kSDYNetWorkProviderOrderListUrl kStrAppendStr(kSDYApiPrefixUrl,@"s=provider&m=order&a=list&shop_id=2")
//@"http://api.origin.3daoyi.com/index.php?s=provider&m=order&a=list&shop_id=2"

//供应商订单详情
#define kSDYNetWorkProviderOrderDetailUrl   kStrAppendStr(kSDYApiPrefixUrl,@"s=provider&m=order&a=detail&order_id=1")
//@"http://api.origin.3daoyi.com/index.php?s=provider&m=order&a=detail&order_id=1"

//供应商提交配送单
#define kSDYNetWorkProviderAddSendOrderUrl kStrAppendStr(kSDYApiPrefixUrl,@"s=provider&m=order&a=add")
//@"http://api.origin.3daoyi.com/index.php?s=provider&m=order&a=add"

//新增订单
#define kSDYNetWorkAddNewOrderUrl   kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=order&a=add")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=order&a=add"

//更新订单
#define kSDYNetWorkUpdateOrderUrl   kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=order&a=update")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=order&a=update"


#pragma mark GET
//订单列表
#define kSDYNetWorkOrderListUrl     kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=order&a=list")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=order&a=list"


//删除订单
#define kSDYNetWorkDeleteOrderUrl   kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=order&a=delete")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=order&a=delete"

//商品(产品)列表
#define kSDYNetWorkProductListUrl   kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=product&a=list")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=product&a=list"
//http://api.origin.3daoyi.com/index.php?s=shop&m=product&a=list
//商品(产品)详情
#define kSDYNetWorkProductDetailUrl  kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=product&a=detail")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=product&a=detail"

//商品分类
#define kSDYNetWorkProductCategoryUrl   kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=product&a=category")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=product&a=category"


#endif /* ConfigurationDefines_h */
