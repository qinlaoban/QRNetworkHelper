//
//  ViewController.m
//  YYCacheAndAFNetwork
//
//  Created by QinRong on 16/9/8.
//  Copyright © 2016年 Qin. All rights reserved.
//

#import "ViewController.h"
#import "QSHCache.h"
#import "QSHNetworkManager.h"
#import <AFNetworking.h>
static NSString *const dataUrl = @"http://api.douban.com/v2/movie/top250?apikey=02d830457f4a8f6d088890d07ddfae47";


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
#warning 断网测试

// 请求完数据默认缓存
- (IBAction)requestData:(id)sender {
    
    [QSHNetworkManager GETCache:dataUrl parameters:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
    }];
    
}
// 计算磁盘大小
- (IBAction)cacheSize:(id)sender {
    [self cacheShow];

    
}

// 清除磁盘文件
- (IBAction)claenCache:(id)sender {
    
    [QSHCache qsh_RemoveAllCache];
    
    [self cacheShow];
}
// 线束
- (void)cacheShow {
    
    [UIView animateWithDuration:1.5 animations:^{
        
        _cacheLabel.text =[QSHCache   qsh_GetAllHttpCacheSize];
        
        _cacheLabel.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:2.5 animations:^{
            
            _cacheLabel.alpha = 0.0;

        
        }];
        
    }];
    
    
}


@end
