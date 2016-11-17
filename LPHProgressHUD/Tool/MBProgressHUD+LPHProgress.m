//
//  MBProgressHUD+LPHProgress.m
//  LPHProgressHUD
//
//  Created by Mac on 16/11/16.
//  Copyright © 2016年 Lph. All rights reserved.
//

#import "MBProgressHUD+LPHProgress.h"

static NSInteger DelayHUDTag  = NSIntegerMax; // 延时消失标志
static NSMutableArray *HUD_DependViews = nil;

@implementation MBProgressHUD (LPHProgress)

+ (instancetype)showLoadingMessage:(NSString *)msg {
    // 非主线程获取的 window 可能为空
    return [MBProgressHUD showMessage:msg inView:[[UIApplication sharedApplication] keyWindow]];
}

+ (instancetype)showLoadingMessage:(NSString *)msg inView:(UIView *)view {
    
    NSAssert(nil != view, @"HUD'superView must not be nil.");
    
    if (nil == HUD_DependViews) {
        
        HUD_DependViews = [NSMutableArray array];
    }
    
    if(![HUD_DependViews containsObject:view]) {
        
        [HUD_DependViews addObject:view];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.userInteractionEnabled = NO;
    hud.detailsLabelText = msg;

    return hud;
}

+ (instancetype)showMessage:(NSString *)msg {
    
    return [MBProgressHUD showMessage:msg hideAfterDelay:NSNotFound];
}

+ (instancetype)showMessage:(NSString *)msg inView:(UIView *)view {
    
    return [MBProgressHUD showMessage:msg inView:view hideAfterDelay:NSNotFound];
}

+ (instancetype)showAutoHideMessage:(NSString *)msg {
    
    return [MBProgressHUD showMessage:msg hideAfterDelay:2];
}

+ (instancetype)showMessage:(NSString *)msg hideAfterDelay:(NSTimeInterval)delay {
    
    return [MBProgressHUD showMessage:msg inView:[[UIApplication sharedApplication] keyWindow] hideAfterDelay:delay];
}

+ (instancetype)showMessage:(NSString *)msg inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    
    NSAssert(nil != view, @"HUD'superView must not be nil.");
    NSAssert(delay >= 0, @"MBProgressHUD auto hideDelay can not less than zero");
    
    if (nil == HUD_DependViews) {
        
        HUD_DependViews = [NSMutableArray array];
    }
    
    if(![HUD_DependViews containsObject:view]) {
        
        [HUD_DependViews addObject:view];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    hud.tag = DelayHUDTag; // 延时消失标志
    
    hud.detailsLabelText = msg;
    
    if(delay != NSNotFound) {
        
        [hud hide:YES afterDelay:delay];
    }
    return hud;
}

+ (void)clearHUD {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [HUD_DependViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // 自带延时隐藏的不能在此隐藏
            NSArray *huds = [MBProgressHUD allHUDsForView:(UIView *)obj];
            for (MBProgressHUD *hud in huds) {
                
                hud.removeFromSuperViewOnHide = YES;
                if(hud.tag != DelayHUDTag) {
                    
                    [hud hide:YES];
                }
            }
        }];
    });
}

@end
