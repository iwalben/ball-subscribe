//
//  YBProgressHUD.m
//  YBProgressHUD
//
//  Created by apple on 2018/6/19.
//

#import "YBProgressHUD.h"
#import <objc/runtime.h>

@interface YBProgressHUD()
{
    NSTimer *_timeOutTimer;
}
@end

@implementation YBProgressHUD
+ (YBProgressHUD *)createHUDWithMessage:(NSString *)msg isWindow:(BOOL)isWindow single:(BOOL)single{
    UIApplication *app = [UIApplication sharedApplication];
    UIView *view;
    if (isWindow) {
        view = (UIView *)app.delegate.window;
    }else{
        UIViewController *vc = [self getCurrentVC];
        if ([vc respondsToSelector:@selector(view)]) {
            view = vc.view;
        }
    }
    
    if (!view) {
        return nil;
    }
    YBProgressHUD *hud;
    if (single) {
        hud = [self hud];
        if (hud == nil) {
            hud = [self createDefaultHUDInView:view];
            objc_setAssociatedObject(app, @selector(hud), hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }else{
        hud = [self createDefaultHUDInView:view];
    }
    hud.detailsLabel.text = msg?msg:@"";
    [view addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}

+ (instancetype)hud{
    UIApplication *app = [UIApplication sharedApplication];
    YBProgressHUD *hud = objc_getAssociatedObject(app, _cmd);
    return hud;
}

+ (YBProgressHUD *)createDefaultHUDInView:(UIView *)view{
    YBProgressHUD *hud = [[self alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    hud.contentColor = [UIColor whiteColor];
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    hud.bezelView.alpha = 0.85;
    return hud;
}
#pragma mark-------------------- show tip ----------------------------
+ (instancetype)showTipMessageInWindow:(NSString*)message{
    return [self showTipMessgae:message isWindow:YES timer:1.5f];
}
+ (instancetype)showTipMessageInView:(NSString *)message{
    return [self showTipMessgae:message isWindow:NO timer:1.5f];
}
+ (instancetype)showTipMessageInWindow:(NSString*)message timer:(int)aTimer{
    return [self showTipMessgae:message isWindow:YES timer:aTimer];
}
+ (instancetype)showTipMessageInView:(NSString *)message timer:(int)aTimer{
    return [self showTipMessgae:message isWindow:NO timer:aTimer];
}
+ (instancetype)showTipMessgae:(NSString *)message isWindow:(BOOL)isWindow timer:(int)aTimer{
    YBProgressHUD *hud = [self createHUDWithMessage:message isWindow:isWindow single:NO];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:aTimer];
    return hud;
}
#pragma mark-------------------- show Activity----------------------------
+ (instancetype)showActivityMessageInWindow:(NSString*)message{
    return [self showActivityMessage:message isWindow:YES timer:0];
}
+ (instancetype)showActivityMessageInView:(NSString*)message{
    return [self showActivityMessage:message isWindow:NO timer:0];
}
+ (instancetype)showActivityMessage:(NSString *)message isWindow:(BOOL)isWindow timer:(int)aTimer{
    YBProgressHUD *hud = [self createHUDWithMessage:message isWindow:isWindow single:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.userInteractionEnabled = YES;
    hud.graceTime = 0.3f;
    if (aTimer>0) {
        [hud hideAnimated:YES afterDelay:aTimer];
    }
    return hud;
}
#pragma mark-------------------- showState ----------------------------
+ (void)showSuccessMessage:(NSString *)Message{
    [self showCustomIconInWindow:@"MBHUD_Success@2x" message:Message];
}
+ (void)showErrorMessage:(NSString *)Message{
    [self showCustomIconInWindow:@"MBHUD_Error@2x" message:Message];
}
+ (void)showInfoMessage:(NSString *)Message{
    [self showCustomIconInWindow:@"MBHUD_Info@2x" message:Message];
}
+ (void)showWarnMessage:(NSString *)Message{
    [self showCustomIconInWindow:@"MBHUD_Warn@2x" message:Message];
}
+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message{
    [self showCustomIcon:iconName message:message isWindow:true];
}
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message{
    [self showCustomIcon:iconName message:message isWindow:false];
}
+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow{
    YBProgressHUD *hud = [self createHUDWithMessage:message isWindow:isWindow single:NO];
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *path = [bundle pathForResource:@"YBProgressHUD_img" ofType:@"bundle"];
    NSBundle *b = [NSBundle bundleWithPath:path];
    NSString *p = [b pathForResource:iconName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:p];
    if (!image) {
        image  = [UIImage imageNamed:iconName];
    }
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    [hud hideAnimated:YES afterDelay:1.5f];
}
#pragma mark-------------------- override ----------------------------
- (void)showAnimated:(BOOL)animated{
    if (_timeOutTimer) {
        [_timeOutTimer invalidate];
        _timeOutTimer = nil;
    }
    _timeOutTimer = [NSTimer timerWithTimeInterval:20.f target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:_timeOutTimer forMode:NSRunLoopCommonModes];
    [super showAnimated:animated];
}
- (void)timeout{
    [self removeFromSuperview];
}
- (void)removeFromSuperview{
    [super removeFromSuperview];
    if (_timeOutTimer) {
        [_timeOutTimer invalidate];
        _timeOutTimer = nil;
    }
}
+ (void)hideHUD{
    UIView *winView =(UIView *)[UIApplication sharedApplication].delegate.window;
    [self hideActivityHUDForView:winView animated:YES];
    UIViewController *vc = [self getCurrentVC];
    if ([vc respondsToSelector:@selector(view)]) {
        [self hideActivityHUDForView:vc.view animated:YES];
    }
}

+ (void)hideActivityHUDForView:(UIView *)view animated:(BOOL)animated{
    YBProgressHUD *hud = (YBProgressHUD *)[self HUDForView:view];
    if (hud.mode != MBProgressHUDModeIndeterminate) {
        return;
    }
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:animated];
    }
}

#pragma mark-------------------- tool ----------------------------
+ (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result=nav.childViewControllers.lastObject;
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}


@end
