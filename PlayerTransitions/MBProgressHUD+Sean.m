//
//  MBProgressHUD+Sean.m
//  RouterTest
//
//  Created by yoyochecknow on 2019/8/12.
//  Copyright © 2019 yoyochecknow. All rights reserved.
//

#import "MBProgressHUD+Sean.h"

@implementation MBProgressHUD (Sean)
#pragma mark 显示一条信息
+ (void)showMessage:(NSString *)message toView:(UIView *)view{
    [self show:message icon:nil view:view];
}

#pragma mark 显示带图片或者不带图片的信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *_Nullable)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
     [MBProgressHUD hideHUDForView:view];//保证这个view上只有一个HUD
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    [hud.label setNumberOfLines:0];
    // 判断是否显示图片
    if (icon == nil) {
        hud.mode = MBProgressHUDModeText;
    }else{
        // 设置图片
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]];
        img = img == nil ? [UIImage imageNamed:icon] : img;
        hud.customView = [[UIImageView alloc] initWithImage:img];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 指定时间之后再消失
    [hud hideAnimated:YES afterDelay:kHudShowTime];
    
}

#pragma mark 显示成功信息
+ (void)showSuccess:(NSString *)success toView:(UIView *)view{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

#pragma mark 显示警告信息
+ (void)showWarning:(NSString *)Warning toView:(UIView *)view{
    [self show:Warning icon:@"warn" view:view];
}

#pragma mark 显示自定义图片信息
+ (void)showMessageWithImageName:(NSString *)imageName message:(NSString *)message toView:(UIView *)view{
    [self show:message icon:imageName view:view];
}

#pragma mark 加载中
+ (MBProgressHUD *)showLoadingWithMessage:(NSString*)message view:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:view];//保证这个view上只有一个HUD
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text  = message;
    [hud.label setNumberOfLines:0];
    // 细节文字
    //    hud.detailsLabelText = @"请耐心等待";
    // 再设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

+ (MBProgressHUD *)showProgressBarToView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text  = @"加载中...";
    return hud;
}



+ (void)showMessage:(NSString *)message{
    [self showMessage:message toView:nil];
}

+ (void)showSuccess:(NSString *)success{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error{
    [self showError:error toView:nil];
}

+ (void)showWarning:(NSString *)Warning{
    [self showWarning:Warning toView:nil];
}

+ (void)showMessageWithImageName:(NSString *)imageName message:(NSString *)message{
    [self showMessageWithImageName:imageName message:message toView:nil];
}

+ (MBProgressHUD *)showLoadingWithMessage:(NSString*)message{
    return [self showLoadingWithMessage:message view:nil];
}




+ (void)hideHUDForView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD{
    [self hideHUDForView:nil];
}
@end
