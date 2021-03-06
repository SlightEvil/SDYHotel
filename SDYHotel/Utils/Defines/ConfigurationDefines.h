//
//  ConfigurationDefines.h
//  SDYHotel
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#ifndef ConfigurationDefines_h
#define ConfigurationDefines_h

//#define kSDYImagePrefix             @"http://www.3daoyi.com"
#define kSDYImagePrefix               @"https://origin.3daoyi.com"
#define kSDYImageUrl(imageUrlSuffix)       kStrAppendStr(kSDYImagePrefix,imageUrlSuffix)

/** 测试网络连接 */
#define kSDYNetWorkReachabilityUrl     @"http://api.origin.3daoyi.com/"
#define kSDYNetWorkBaiduUrl         @"https://www.baidu.com"

/** 三道易API前缀URL */
#define kSDYApiPrefixUrl      @"http://api.origin.3daoyi.com/index.php?"

#pragma mark - POST

/** 酒店用户登录 */
#define kAPIURLShopLogin kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=index&a=login")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=index&a=login"

/** 供应商用户登录 */
#define kAPIURLProviderLogin    kStrAppendStr(kSDYApiPrefixUrl,@"s=provider&m=index&a=login")
//@"http://api.origin.3daoyi.com/index.php?s=provider&m=index&a=login"

/** 供应商重置密码 */
#define kAPIURLProviderREPSW     kStrAppendStr(kSDYApiPrefixUrl,@"s=provider&m=index&a=repsw")
//@"http://api.origin.3daoyi.com/index.php?s=provider&m=index&a=repsw"

/** 供应商订单列表 */
#define kAPIURLProviderOrderList kStrAppendStr(kSDYApiPrefixUrl,@"s=provider&m=order&a=list&shop_id=2")
//@"http://api.origin.3daoyi.com/index.php?s=provider&m=order&a=list&shop_id=2"

/** 供应商订单详情 */
#define kAPIURLProviderOrderDetail kStrAppendStr(kSDYApiPrefixUrl,@"s=provider&m=order&a=detail&order_id=1")
//@"http://api.origin.3daoyi.com/index.php?s=provider&m=order&a=detail&order_id=1"

/** 供应商提交配送单 */
#define kAPIURLProviderAddSendOrder kStrAppendStr(kSDYApiPrefixUrl,@"s=provider&m=order&a=add")
//@"http://api.origin.3daoyi.com/index.php?s=provider&m=order&a=add"

/** 新增订单 */
#define kAPIURLAddNewOrder   kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=order&a=add")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=order&a=add"

/** 更新订单 */
#define kAPIURLUpdateOrder kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=order&a=update")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=order&a=update"


#pragma mark GET
/** 订单列表 */
#define kAPIURLOrderList kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=order&a=list")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=order&a=list"

/** 更新订单状态 */
#define kAPIURLUpdateOrderStatus kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=order&a=status")
//http://api.origin.3daoyi.com/index.php?s=shop&m=order&a=status

/** 删除订单 */
#define kAPIURLDeleteOrder kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=order&a=delete")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=order&a=delete"

/** 商品(产品)列表 */
#define kAPIURLProductList kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=product&a=list")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=product&a=list"
//http://api.origin.3daoyi.com/index.php?s=shop&m=product&a=list
/** 商品(产品)详情 */
#define kAPIURLProductDetail kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=product&a=detail")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=product&a=detail"

/** 商品分类 */
#define kAPIURLProductCategory kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=product&a=category")
//@"http://api.origin.3daoyi.com/index.php?s=shop&m=product&a=category"

/** 收藏商品 */
#define kAPIURLRecordProduct kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=favor&a=add")
//http://api.origin.3daoyi.com/index.php?s=shop&m=favor&a=add

/** 收藏商品列表 */
#define kAPIURLReocrdProductList kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=favor&a=list")
//http://api.origin.3daoyi.com/index.php?s=shop&m=favor&a=list

/** 删除收藏 */
#define kAPIURLCancelRecordProduct  kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=favor&a=delete")
//http://api.origin.3daoyi.com/index.php?s=shop&m=favor&a=delete

/** 资金账户预览 */
#define kAPIURLAccountMoney   kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=account&a=show")
//http://api.origin.3daoyi.com/index.php?s=shop&m=account&a=show

/** 交易流水 */
#define kAPIURLAccountLog   kStrAppendStr(kSDYApiPrefixUrl,@"s=shop&m=account&a=logs")
//http://api.origin.3daoyi.com/index.php?s=shop&m=account&a=logs

#endif /* ConfigurationDefines_h */
