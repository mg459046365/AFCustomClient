//
//  AFCustomClient.h
//  AFCustomClient
//
//  Created by Cindy on 14-10-24.
//  Copyright (c) 2014年 plusub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
typedef enum HttpMethod{
    HttpMethodGet      = 0,
    HttpMethodPost     = 1
}HttpMethod;



@class AFCustomClient;

typedef void (^HTTPRequestV2SuccessWithWIFIBlock)(AFCustomClient *request, id responseObject);
typedef void (^HTTPRequestV2SuccessWithWWAWBlock)(AFCustomClient *request, id responseObject);
typedef void (^HTTPRequestV2FailedBlock)(AFCustomClient *request, NSError *error);
typedef void (^HTTPRequestV2NetworkBlock)(void);

@interface AFCustomClient : NSObject<NSCopying>

#pragma mark 单例模式下的afnetworking
+ (instancetype)sharedClient;


#pragma mark 方法1.same wifi下与wwaw下使用统一方法处理函数
+ (void)requestSameWithHttpMethod:(HttpMethod)httpMethod
                       URLStr:(NSString *)URLString
                       params:(NSDictionary *)params
                 networkBlock:(HTTPRequestV2NetworkBlock)networkReqBlock
                 successBlock:(HTTPRequestV2SuccessWithWIFIBlock)successReqBlock
                  failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;


#pragma mark 方法2.diff wifi下与wwaw下使用不同方法处理函数
+ (void)requestDiffWithHttpMethod:(HttpMethod)httpMethod
                       URLStr:(NSString *)URLString
                       params:(NSDictionary *)params
                 networkBlock:(HTTPRequestV2NetworkBlock)networkReqBlock
            successWithWifiBlock:(HTTPRequestV2SuccessWithWIFIBlock)successWithWIFiReqBlock
            successWithWWAWBlock:(HTTPRequestV2SuccessWithWWAWBlock)successWithWWAWReqBlock
                  failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;


#pragma mark 方法3.uploa post请求 实现上传功能
+ (void)requestUploadWithHttpPostWithURLStr:(NSString *)URLString
                                     params:(NSDictionary *)params
                               fileLocalUrl:(NSString *)fileUrl
                               fileFormName:(NSString *)fileName
                               networkBlock:(HTTPRequestV2NetworkBlock)networkReqBlock
                               successBlock:(HTTPRequestV2SuccessWithWIFIBlock)successReqBlock
                                failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock;





#pragma mark 检测网络连接状态
+ (AFNetworkReachabilityStatus)requestNetworkingStatus;

@end
