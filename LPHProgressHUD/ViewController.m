//
//  ViewController.m
//  LPHProgressHUD
//
//  Created by Mac on 16/11/16.
//  Copyright © 2016年 Lph. All rights reserved.
//

#import "ViewController.h"
#import "LPHRequestTool.h"
#import "MBProgressHUD+LPHProgress.h"

NSString *baseUrl = @"http://xxxxx";      //测试地址
//NSString *baseUrl = @"http://xxxxx";    //生产地址
NSString *requStr1 = @"xxxx/xxxx";            //url需要拼接的地址 1
NSString *requStr2 = @"xxxxx";            //url需要拼接的地址 2

@interface ViewController ()

@property (nonatomic, strong) LPHRequestTool *requestManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    LPHRequestTool *requestManager = [LPHRequestTool sharedManager];
    self.requestManager = requestManager;
    
    //请求 1
    [self.requestManager jsonRequest:requStr1 HTTPMethod:@"GET" parameters:nil loadingString:@"正在请求中.." success:^(NSURLSessionDataTask *operation, id responseObject) {
    
        if (responseObject != nil) {

            [MBProgressHUD showAutoHideMessage:responseObject[@"xxx"][@"xxx"]];
            NSLog(@"--%@", responseObject);
        } else {
            
            //这里可以show后台返回的错误码
            [MBProgressHUD showAutoHideMessage:responseObject[@""]];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        [MBProgressHUD showAutoHideMessage:@"网络异常，请稍后重试"];
        
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //请求 2
    [self.requestManager jsonRequest:requStr1 HTTPMethod:@"POST" parameters:@{} loadingString:@"正在请求中.." success:^(NSURLSessionDataTask *operation, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        
    }];
}

@end
