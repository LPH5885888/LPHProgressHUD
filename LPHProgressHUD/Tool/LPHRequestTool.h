//
//  LPHRequestTool.h
//  LPHProgressHUD
//
//  Created by Mac on 16/11/16.
//  Copyright © 2016年 Lph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

extern NSString *baseUrl;
@interface LPHRequestTool : NSObject

// 显示HUD
@property (nonatomic, copy) void (^showLoadingBlock)(NSString *loadingID, NSString *loadingString);
// 删除HUD
@property (nonatomic, copy) void (^remoLoadingBlock)(NSString *loadingID);

+ (instancetype)sharedManager;

/*! 发起网络请求
 \param  URLString 请求地址不带 IP 的地址
 \param  postData 请求体
 \param  loadingStr 需要提示的HUD
 \param  success 成功回调
 \param  failure 失败回调
 \return 请求
 */
- (NSURLSessionTask *)jsonRequest:(NSString *)URLString
                       parameters:(NSDictionary *)postData
                    loadingString:(NSString *)loadingStr
                          success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

@end
