//
//  MBProgressHUD+Sean.h
//  RouterTest
//
//  Created by yoyochecknow on 2019/8/12.
//  Copyright © 2019 yoyochecknow. All rights reserved.
//
// 统一的显示时长
#import "MBProgressHUD.h"
#define kHudShowTime 1.5

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Sean)
#pragma mark 在指定的view上显示hud
+ (void)showMessage:(NSString *)message toView:(UIView *_Nullable)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *_Nullable)view;
+ (void)showError:(NSString *)error toView:(UIView *_Nullable)view;
+ (void)showWarning:(NSString *)Warning toView:(UIView *_Nullable)view;
+ (void)showMessageWithImageName:(NSString *)imageName message:(NSString *)message toView:(UIView *_Nullable)view;
+ (MBProgressHUD *)showLoadingWithMessage:(NSString*)message view:(UIView *_Nullable)view;
+ (MBProgressHUD *)showProgressBarToView:(UIView *_Nullable)view;


#pragma mark 在window上显示hud
+ (void)showMessage:(NSString *)message;
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (void)showWarning:(NSString *)Warning;
+ (void)showMessageWithImageName:(NSString *)imageName message:(NSString *)message;
+ (MBProgressHUD *)showLoadingWithMessage:(NSString*)message;


#pragma mark 移除hud
+ (void)hideHUDForView:(UIView *_Nullable)view;
+ (void)hideHUD;
@end

NS_ASSUME_NONNULL_END
