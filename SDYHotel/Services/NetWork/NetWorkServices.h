//
//  NetWorkServices.h
//  SDYHotel
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSDictionary *data,NSString *errorDescription);
typedef void(^FailBlock)(NSString *errorDescription);


/**
 默认使用 普通格式上传，自己解析数据
 */
@interface NetWorkServices : NSObject

/**
 GET 请求 参数为 成功返回自己解析过的字典，失败返回失败描述

 @param urlString 请求接口
 @param parameters 参数
 @param successBlock success callback(json 过的字典)
 @param failBlock fail callback(错误描述)
 */
- (void)GET:(NSString *)urlString parameters:(id)parameters success:(SuccessBlock)successBlock faile:(FailBlock)failBlock;

/**
 POST 请求  。parameter 参数，成功返回自己解析过的字典 ，失败返回失败描述

 @param urlString 请求接口
 @param parameters 参数
 @param successBlock success callback(json 过的字典)
 @param failBlock callback(错误描述)
 */
- (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock  fail:(FailBlock)failBlock;



@end
