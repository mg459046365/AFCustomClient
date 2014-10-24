//
//  AFCustomClient.m
//  AFCustomClient
//
//  Created by Cindy on 14-10-24.
//  Copyright (c) 2014年 plusub. All rights reserved.
//

#import "AFCustomClient.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"https://api.app.net/";

@implementation AFCustomClient

#pragma mark 单例模式下的afnetworking
+ (instancetype)sharedClient {
    static id _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        CGFloat  sysVersion = [[UIDevice currentDevice].systemVersion floatValue];//判断系统os版本
        if (sysVersion < 7.0) {//如果小于7.0 则使用AFHTTPRequestOperationManager
            _sharedClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
            
        }else{//如果大于7.0 则使用AFHTTPSessionManager
            _sharedClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        }
    });
    return _sharedClient;
}


#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    AFCustomClient  *client = [[self class] init];
    return client;
}


#pragma mark 方法1.same wifi下与wwaw下使用统一方法处理函数
+(void)requestSameWithHttpMethod:(HttpMethod)httpMethod URLStr:(NSString *)URLString params:(NSDictionary *)params networkBlock:(HTTPRequestV2NetworkBlock)networkReqBlock successBlock:(HTTPRequestV2SuccessWithWIFIBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock
{
    CGFloat  sysVersion = [[UIDevice currentDevice].systemVersion floatValue];//判断系统os版本
    AFNetworkReachabilityStatus status = [self requestNetworkingStatus];
    
    if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {//拦截器，如果没有网络情况下，不再执行网络请求
        networkReqBlock();//执行network方法
        return;
    }else if(status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN){//在移动网络下执行方法 与 在wifi情况下执行的方法
        if (sysVersion < 7.0) {//os版本小于7.0执行
            if (httpMethod == HttpMethodGet) {
                
                [[self sharedClient] GET:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if (successReqBlock) {
                        successReqBlock([self sharedClient], responseObject);
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (failedReqBlock) {
                        failedReqBlock([self sharedClient], error);
                    }
                }];
                
            }else if (httpMethod == HttpMethodPost){
                [[self sharedClient] POST:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if (successReqBlock) {
                        successReqBlock([self sharedClient], responseObject);
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (failedReqBlock) {
                        failedReqBlock([self sharedClient], error);
                    }
                }];
                
            }
        }else{//os版本大于7.0执行
            AFHTTPSessionManager   *httpClient = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
            if (httpMethod == HttpMethodGet) {
                
                [httpClient GET:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    if (successReqBlock) {
                        successReqBlock([self sharedClient], responseObject);
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    if (failedReqBlock) {
                        failedReqBlock([self sharedClient], error);
                    }
                }];
                
            }else if (httpMethod == HttpMethodPost){
                
                [httpClient POST:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    if (successReqBlock) {
                        successReqBlock([self sharedClient], responseObject);
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    if (failedReqBlock) {
                        failedReqBlock([self sharedClient], error);
                    }
                }];
                
            }
        }
    }
}

#pragma mark 方法2.diff wifi下与wwaw下使用不同方法处理函数
+(void)requestDiffWithHttpMethod:(HttpMethod)httpMethod URLStr:(NSString *)URLString params:(NSDictionary *)params networkBlock:(HTTPRequestV2NetworkBlock)networkReqBlock successWithWifiBlock:(HTTPRequestV2SuccessWithWIFIBlock)successWithWIFiReqBlock successWithWWAWBlock:(HTTPRequestV2SuccessWithWWAWBlock)successWithWWAWReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock
{
    CGFloat  sysVersion = [[UIDevice currentDevice].systemVersion floatValue];//判断系统os版本
    AFNetworkReachabilityStatus status = [self requestNetworkingStatus];
    
    if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {//拦截器，如果没有网络情况下，不再执行网络请求
        networkReqBlock();//执行network方法
        return;
    }else if(status == AFNetworkReachabilityStatusReachableViaWiFi){//在wifi情况下执行的方法
        if (sysVersion < 7.0) {//os版本小于7.0执行
            if (httpMethod == HttpMethodGet) {
                
                [[self sharedClient] GET:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if (successWithWIFiReqBlock) {
                        successWithWIFiReqBlock([self sharedClient], responseObject);
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (failedReqBlock) {
                        failedReqBlock([self sharedClient], error);
                    }
                }];
                
            }else if (httpMethod == HttpMethodPost){
                [[self sharedClient] POST:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if (successWithWIFiReqBlock) {
                        successWithWIFiReqBlock([self sharedClient], responseObject);
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (failedReqBlock) {
                        failedReqBlock([self sharedClient], error);
                    }
                }];
                
            }
        }else{//os版本大于7.0执行
            AFHTTPSessionManager   *httpClient = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
            if (httpMethod == HttpMethodGet) {
                
                [httpClient GET:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    if (successWithWIFiReqBlock) {
                        successWithWIFiReqBlock([self sharedClient], responseObject);
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    if (successWithWIFiReqBlock) {
                        successWithWIFiReqBlock([self sharedClient], error);
                    }
                }];
                
            }else if (httpMethod == HttpMethodPost){
                
                [httpClient POST:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    if (successWithWIFiReqBlock) {
                        successWithWIFiReqBlock([self sharedClient], responseObject);
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    if (failedReqBlock) {
                        failedReqBlock([self sharedClient], error);
                    }
                }];
                
            }
        }
    
    }else if(status == AFNetworkReachabilityStatusReachableViaWWAN){//在移动网络下执行方法
        if (sysVersion < 7.0) {//os版本小于7.0执行
            if (httpMethod == HttpMethodGet) {
                
                [[self sharedClient] GET:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if (successWithWWAWReqBlock) {
                        successWithWWAWReqBlock([self sharedClient], responseObject);
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (failedReqBlock) {
                        failedReqBlock([self sharedClient], error);
                    }
                }];
                
            }else if (httpMethod == HttpMethodPost){
                [[self sharedClient] POST:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if (successWithWWAWReqBlock) {
                        successWithWWAWReqBlock([self sharedClient], responseObject);
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (failedReqBlock) {
                        failedReqBlock([self sharedClient], error);
                    }
                }];
                
            }
        }else{//os版本大于7.0执行
            AFHTTPSessionManager   *httpClient = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
            if (httpMethod == HttpMethodGet) {
                
                [httpClient GET:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    if (successWithWWAWReqBlock) {
                        successWithWWAWReqBlock([self sharedClient], responseObject);
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    if (successWithWWAWReqBlock) {
                        successWithWWAWReqBlock([self sharedClient], error);
                    }
                }];
                
            }else if (httpMethod == HttpMethodPost){
                
                [httpClient POST:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    if (successWithWWAWReqBlock) {
                        successWithWWAWReqBlock([self sharedClient], responseObject);
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    if (failedReqBlock) {
                        failedReqBlock([self sharedClient], error);
                    }
                }];
                
            }
        }
    }
}


#pragma mark 方法3.uploa post请求 实现上传功能
+(void)requestUploadWithHttpPostWithURLStr:(NSString *)URLString params:(NSDictionary *)params fileLocalUrl:(NSString *)fileUrl fileFormName:(NSString *)fileName networkBlock:(HTTPRequestV2NetworkBlock)networkReqBlock successBlock:(HTTPRequestV2SuccessWithWIFIBlock)successReqBlock failedBlock:(HTTPRequestV2FailedBlock)failedReqBlock
{
//    CGFloat  sysVersion = [[UIDevice currentDevice].systemVersion floatValue];//判断系统os版本
    AFNetworkReachabilityStatus status = [self requestNetworkingStatus];
    
    if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {//拦截器，如果没有网络情况下，不再执行网络请求
        networkReqBlock();//执行network方法
        return;
    }else if(status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN){
//        if (sysVersion < 7.0) {
            NSURL *filePath = [NSURL fileURLWithPath:fileUrl];
            [[self sharedClient] POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileURL:filePath name:fileName error:nil];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (successReqBlock) {
                    successReqBlock([self sharedClient], responseObject);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failedReqBlock) {
                    failedReqBlock([self sharedClient], error);
                }
            }];
//        }else{
//        
//            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//            
//            NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
//            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//            
//            NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
//            NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//                if (error) {
//                    NSLog(@"Error: %@", error);
//                } else {
//                    NSLog(@"Success: %@ %@", response, responseObject);
//                }
//            }];
//            [uploadTask resume];
//        
//        
//        }
    }

}







#pragma mark 检测网络连接状态
+(AFNetworkReachabilityStatus)requestNetworkingStatus
{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                break;
            }
            default:
                break;
        }
        
    }];
    
    //    BOOL t = [AFNetworkReachabilityManager sharedManager].isReachable;
    return [AFNetworkReachabilityManager sharedManager].isReachable;


}








@end
