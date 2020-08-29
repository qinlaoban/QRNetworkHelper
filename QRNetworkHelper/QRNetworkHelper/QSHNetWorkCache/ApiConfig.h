//
//  ApiConfig.h
//  QRNetworkHelper
//
//  Created by Qin on 2020/4/20.
//  Copyright © 2020 Qin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjSingle.h"
NS_ASSUME_NONNULL_BEGIN

@interface ApiConfig : NSObject
ObjSingleH;


// 无缓存
+ (void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))resposeValue;

// 有缓存
+ (void)GETCache:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))resposeValue ;

+ (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))resposeValue;

+ (void)POSTCache:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))resposeValue ;

// 上传图片,可多张上传
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
constructingBodyWithFormDataArray:(NSArray *)formDataArray
     success:(void (^)( id responseObject))success
     failure:(void (^)( NSError *error))failure;

@end



/*QSHNetworkManager使用POST添加文件时使用的文件类*/
@interface FormData : NSObject
/**请求参数名*/
@property (nonatomic, copy, readwrite) NSString *name;
/**保存到服务器的文件名*/
@property (nonatomic, copy, readwrite) NSString *fileName;
/**文件类型*/
@property (nonatomic, copy, readwrite) NSString *mimeType;
/**二进制数据*/
@property (nonatomic, strong, readwrite) NSData *data;
@end

NS_ASSUME_NONNULL_END
