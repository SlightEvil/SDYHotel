//
//  NetWorkServices.m
//  SDYHotel
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "NetWorkServices.h"
#import <AFNetworking.h>


@interface NetWorkServices ()

@property (nonatomic) AFHTTPSessionManager *manager;

@property (nonatomic) AFNetworkReachabilityManager *reachableManager;


@end

@implementation NetWorkServices

- (void)GET:(NSString *)urlString parameters:(id)parameters success:(SuccessBlock)successBlock faile:(FailBlock)failBlock
{
    [self.manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            NSError *error;
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            successBlock(dataDic,error.localizedDescription);
        } else {
            successBlock(nil,@"暂无数据");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error.localizedDescription);
    }];
}


- (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock fail:(FailBlock)failBlock
{
    [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSError *error;
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            successBlock(dataDic,error.localizedDescription);
        } else {
            successBlock(nil,@"暂无数据");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error.localizedDescription);
        }
    }];
}



#pragma mark -  

- (AFHTTPSessionManager *)manager {
    
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//     _manager.requestSerializer = [AFJSONRequestSerializer serializer]; //上传json 格式
//     _manager.responseSerializer = [AFJSONResponseSerializer serializer]; //AFN json 解析返回的数据
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
