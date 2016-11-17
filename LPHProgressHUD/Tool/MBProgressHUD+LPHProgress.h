//
//  MBProgressHUD+LPHProgress.h
//  LPHProgressHUD
//
//  Created by Mac on 16/11/16.
//  Copyright © 2016年 Lph. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (LPHProgress)
// show HUD in window
+ (instancetype)showLoadingMessage:(NSString *)msg;
+ (instancetype)showLoadingMessage:(NSString *)msg inView:(UIView *)view;

// show 完不会隐藏
+ (instancetype)showMessage:(NSString *)msg;
+ (instancetype)showMessage:(NSString *)msg inView:(UIView *)view;

//show一段文字 默认2秒后隐藏
+ (instancetype)showAutoHideMessage:(NSString *)msg;
+ (instancetype)showMessage:(NSString *)msg hideAfterDelay:(NSTimeInterval)delay;

+ (instancetype)showMessage:(NSString *)msg inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
// remove all HUD
+ (void)clearHUD;

@end
