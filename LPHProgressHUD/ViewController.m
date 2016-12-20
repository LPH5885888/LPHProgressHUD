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


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    LPHRequestTool *requestManager = [LPHRequestTool sharedManager];
    
    [requestManager jsonRequest:@"" HTTPMethod:@"GET" parameters:nil loadingString:@"正在请求中.." success:^(NSURLSessionDataTask *operation, id responseObject) {
    
        if (responseObject != nil) {

            [MBProgressHUD showAutoHideMessage:responseObject[@""][@""]];
            NSLog(@"--%@", responseObject);
        } else {
            
            [MBProgressHUD showAutoHideMessage:responseObject[@""]];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        [MBProgressHUD showAutoHideMessage:@"网络异常，请稍后重试"];
        
    }];
}

@end
