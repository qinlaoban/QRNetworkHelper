

//
//  ObjSingle.h
//
//
//  Created by Qin on 16/6/7.
//  Copyright © 2016年 mac. All rights reserved.
//

// 单例文件

// .头文件

#define ObjSingleH + (instancetype)shareInstace;


#define ObjSingleM \
static id _instance;\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    \
    static dispatch_once_t onceToken;\
    \
    dispatch_once(&onceToken, ^{\
      \
        _instance = [super allocWithZone:zone];\
    });\
    \
    return  _instance;\
 \
}\
+ (instancetype)shareInstace{\
    \
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        \
        _instance = [[self alloc]init];\
    });\
    \
    return _instance;\
}\
- (id)copyWithZone:(NSZone *)zone{\
    \
    return _instance;\
} 