//
//  NetWorkServices.m
//  SDYHotel
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "NetWorkServices.h"
#import <AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>


@interface NetWorkServices ()

@property (nonatomic) AFHTTPSessionManager *manager;

@property (nonatomic) AFNetworkReachabilityManager *reachableManager;


@end

@implementation NetWorkServices

- (void)GET:(NSString *)urlString parameters:(id)parameters success:(SuccessBlock)successBlock faile:(FailBlock)failBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    if (APPCT.loginUser.user_id && APPCT.loginUser.token) {
        [dic setObject:APPCT.loginUser.user_id forKey:@"uid"];
        [dic setObject:APPCT.loginUser.token forKey:@"token"];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    [self.manager GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        successBlock(responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }];
}

- (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock fail:(FailBlock)failBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error.localizedDescription);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }];
}


///** 替换 Null 为 “” */
//- (NSData *)jsonReplaceNull:(NSData *)data
//{
//    NSString *jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    jsonString =  [jsonString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
//    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//}


#pragma mark -  

- (AFHTTPSessionManager *)manager {
    
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
// 上传json格式
//     _manager.requestSerializer = [AFJSONRequestSerializer serializer];

        
//        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//AFN json 解析返回的数据  (back dictionary)
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //设置返回类型
//        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    return _manager;
}

- (AFNetworkReachabilityManager *)reachableManager
{
    if (!_reachableManager) {
        _reachableManager = [AFNetworkReachabilityManager sharedManager];
        [_reachableManager startMonitoring];
    }
    return _reachableManager;
}



/*
AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
[manager startMonitoring];

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没网");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"不知道");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"4g");
                break;
 
            default:
                break;
        }
    }];
 */

@end
