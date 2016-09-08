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



+ (void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))resposeValue{

    [self starInfocatorVisible];
    
    [[self AFNetManager] GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        resposeValue(responseObject);
        
        [self stopIndicatorVisible];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
        [self showError:error.localizedDescription];
        
    }];

}

+ (void)GETCache:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id))resposeValue {
    
    [self starInfocatorVisible];
    
    [[self AFNetManager] GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
      
        
        
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
    
    
    [[self AFNetManager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (FormData * data in formDataArray) {
            [formData appendPartWithFileData:data.data name:data.name fileName:data.fileName mimeType:data.mimeType];
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
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
        
    });
    
    return manager;
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
