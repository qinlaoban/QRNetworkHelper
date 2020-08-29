//
//  QSHCache.m
//  
//
//  Created by Qin on 16/6/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "QSHCache.h"
#import "YYCache.h"


@implementation QSHCache


// 

ObjSingleM;

// YYCache 缓存的文件名称,默认缓存在library的cache文件下面

static NSString *const qshCache = @"qsh_Cache";

static YYCache *_dataCache;


+ (void)initialize  {
    
    [super initialize];
    
    // 实例化方式一
    
    _dataCache = [[YYCache alloc] initWithName:qshCache];
    
}

+ (void)qsh_saveDataCache:(id)data forKey:(NSString *)key {
    
   // [[self sharedManager]setObject:data forKey:key];
    
    // 默认会开启线程缓存
    
    [_dataCache setObject:data forKey:key withBlock:nil];
    
}

+ (id)qsh_ReadCache:(NSString *)key {
    
   return  [_dataCache objectForKey:key];
    
}





+ (NSString *)qsh_GetAllHttpCacheSize
{
    
    
    // 总大小
    unsigned long long diskCache = [_dataCache.diskCache totalCost];
    
    NSString *sizeText = nil;
    
    if (diskCache >= pow(10, 9)) {
        // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", diskCache / pow(10, 9)];
    } else if (diskCache >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", diskCache / pow(10, 6)];
    } else if (diskCache >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", diskCache / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%zdB", diskCache];
    }
    

    return sizeText ;

}

+ (BOOL)qsh_IsCache:(NSString *)key {
    
    return [_dataCache containsObjectForKey:key];
}

+ (void)qsh_RemoveChache:(NSString *)key {
    
    [_dataCache removeObjectForKey:key withBlock:nil];
}

+ (void)qsh_RemoveAllCache {
    
    [_dataCache removeAllObjects];
}


@end
