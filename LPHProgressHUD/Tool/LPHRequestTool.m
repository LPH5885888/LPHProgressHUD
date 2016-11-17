//
//  LPHRequestTool.m
//  LPHProgressHUD
//
//  Created by Mac on 16/11/16.
//  Copyright © 2016年 Lph. All rights reserved.
//

#import "LPHRequestTool.h"
#import "MBProgressHUD+LPHProgress.h"

@interface LPHRequestTool ()

@property (nonatomic, strong) AFHTTPSessionManager *requestManager;
@property (nonatomic, strong) NSMutableDictionary  *loadingPool;
@end

@implementation LPHRequestTool

+ (instancetype)sharedManager {

    static LPHRequestTool *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        instance = [[LPHRequestTool alloc] init];
    });
    return instance;
}

- (instancetype)init {

    self = [super init];
    if (self) {
        
        self.requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestManager.requestSerializer.timeoutInterval = 10;
        self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", nil];
        
        [self setDefaultLoading];
    }
    
    return self;
}

- (NSURLSessionTask *)jsonRequest:(NSString *)URLString
                       parameters:(NSDictionary *)postData
                    loadingString:(NSString *)loadingStr
                          success:(void (^)(NSURLSessionDataTask *, id))success
                          failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    // 如果url地址有特殊符号 就可以调用序列化
    URLString = [URLString  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *fullURLStr = [[NSURL URLWithString:URLString relativeToURL:self.requestManager.baseURL] absoluteString];
    NSLog(@"URLString:%@", fullURLStr);

    NSString *loadingID = fullURLStr;
    self.showLoadingBlock(loadingID, loadingStr);
    
    NSURLSessionDataTask *dataTask = [self.requestManager POST:URLString parameters:postData progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (self.remoLoadingBlock != nil) {
            
            self.remoLoadingBlock(loadingID);
        }
        if (success != nil) {
            
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (self.remoLoadingBlock != nil) {
            
            self.remoLoadingBlock(loadingID);
        }
        
        if (failure != nil) {
            
            failure(task, error);
        }
    }];
    
    return dataTask;
}

- (void)setDefaultLoading {

    self.loadingPool = [NSMutableDictionary dictionary];
    
    __weak typeof(self) weakSelf = self;
    [self setShowLoadingBlock:^(NSString *loadingID, NSString *loadingString) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            MBProgressHUD *mbHud = [MBProgressHUD showLoadingMessage:loadingString];
            
            [weakSelf.loadingPool setObject:mbHud forKey:loadingID];
        });
    }];
    
    [self setRemoLoadingBlock:^(NSString *loadingID) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            MBProgressHUD *mbHud = [weakSelf.loadingPool objectForKey:loadingID];
            
            if (mbHud != nil) {
                
                [mbHud hide:YES];
            }
        });
    }];
}

@end
