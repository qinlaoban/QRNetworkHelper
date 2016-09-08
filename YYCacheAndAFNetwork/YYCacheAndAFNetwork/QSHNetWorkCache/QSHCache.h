//
//  QSHCache.h
//
//
//  Created by Qin on 16/6/7.
//  Copyright © 2016年 mac. All rights reserved.
//

//  此类方便YYCache的统一调用


#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "ObjSingle.h"

@interface QSHCache : NSObject <NSCopying>


ObjSingleH;



/**
 *   存 或 改
 *
 * 
 
 
 data :网络数据
 *
 *  key : key
 */
+ (void)qsh_saveDataCache:(id)data forKey:(NSString *)key;

/**读取*/
+ (id)qsh_ReadCache:(NSString *)key ;

/**读取缓存文件的大小*/
+ (NSString *)qsh_GetAllHttpCacheSize ;

/**是否缓存*/
+ (BOOL)qsh_IsCache:(NSString *)key ;

/**删除某个磁盘缓存文件*/
+ (void)qsh_RemoveChache:(NSString *)key ;

/**删除所有的磁盘换存文件*/
+ (void)qsh_RemoveAllCache ;



@end
