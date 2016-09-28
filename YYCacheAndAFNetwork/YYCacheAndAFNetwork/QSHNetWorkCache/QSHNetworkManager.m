//
//  QSHNetworkManager.m
//  
//
//  Created by Qin on 16/6/7.
//  Copyright © 2016年 秦. All rights reserved.
//

#import "QSHNetworkManager.h"

#import <AFNetworking.h>

#import "SVProgressHUD.h"

#import "QSHCache.h"

@interface QSHNetworkManager ()


@end

@implementation QSHNetworkManager

ObjSingleM;

+(void)loginPOST {
    
    AFHTTPSessionManager *manager = [self AFNetManager];
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:NO];
    
   
    
    manager.securityPolicy = securityPolicy;
    
    
}




+ (void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))resposeValue{

    [self starInfocatorVisible];
    
    [[self AFNetManager] GET:urlString
                         parameters:parameters
                         progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        resposeValue(responseObject);
        
        [self stopIndicatorVisible];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
        [self showError:error.localizedDescription];
        
    }];

}

+ (void)GETCache:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id))resposeValue {
    
    [self starInfocatorVisible];
    
    [[self AFNetManager] GET:urlString
                         parameters:parameters
                         progress:^(NSProgress * _Nonnull downloadProgress) {
      
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        resposeValue (responseObject);
        
        [QSHCache qsh_saveDataCache:responseObject forKey:urlString];
        
        [self stopIndicatorVisible];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        resposeValue([QSHCache qsh_ReadCache:urlString]);
        
        [self showError:error.localizedDescription];
        
    }];

}

+ (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))resposeValue {
    
    
    [self starInfocatorVisible];
    
    [[self AFNetManager] POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        resposeValue (responseObject);
        
        [self stopIndicatorVisible];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
        [self showError:error.localizedDescription];
        
    }];
}

+ (void)POSTCache:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id))resposeValue {

    [self starInfocatorVisible];
    
    
    [[self AFNetManager] POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        resposeValue (responseObject);
        
        [QSHCache qsh_saveDataCache:responseObject forKey:urlString];
        
        [self stopIndicatorVisible];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        resposeValue([QSHCache qsh_ReadCache:urlString]);
        
        [self showError:error.localizedDescription];
        
    }];
}



+ (void)POST:(NSString *)URLString
        parameters:(id)parameters
constructingBodyWithFormDataArray:(NSArray<FormData *> *)formDataArray
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    
    
    [[self AFNetManager] POST:URLString
                         parameters:parameters
                         constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (FormData * data in formDataArray) {
            [formData appendPartWithFileData:data.data
                      name:data.name
                      fileName:data.fileName
                      mimeType:data.mimeType];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        

        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //   [MBProgressHUD showMessage:error.localizedDescription];
        
        failure(error);
    }];
    
}

/**
 *  公用一个AFHTTPSessionManager
 *
 *  @return AFHTTPSessionManager
 */
+ (AFHTTPSessionManager *)AFNetManager
{
    
    static AFHTTPSessionManager *manager;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [AFHTTPSessionManager manager];
        
        //设置请求的超时时间
        manager.requestSerializer.timeoutInterval = 20.f;
        
        
        manager.securityPolicy = [self customSecurityPolicy];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
        
    });
    
    return manager;
}

// SSL认证
+ (AFSecurityPolicy*)customSecurityPolicy

{
    // /先导入证书,证书导入项目中
    
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"YourCertificate" ofType:@"cer"];//证书的路径
    
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    
    // 如果是需要验证自建证书，需要设置为YES
    
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    
    //如置为NO，建议自己添加对应域名的校验逻辑。
    
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
    
}


#pragma mark - 网络加载相关

+ (void)starInfocatorVisible {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark ];
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
    [SVProgressHUD show ];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack ];
    
}


+ (void)stopIndicatorVisible {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [SVProgressHUD dismiss];

}

+ (void)showError:(NSString *)errorString {
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [SVProgressHUD showWithStatus:errorString];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark ];
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack ];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [SVProgressHUD  dismiss];
        
    });
    
}





@end
