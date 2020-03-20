//
//  YBProgressHUD.h
//  YBProgressHUD
//
//  Created by apple on 2018/6/19.
//

#import "MBProgressHUD.h"

@interface YBProgressHUD : MBProgressHUD
//showTips
+ (instancetype)showTipMessageInWindow:(NSString*)message;
+ (instancetype)showTipMessageInView:(NSString *)message;
+ (instancetype)showTipMessageInWindow:(NSString*)message timer:(int)aTimer;
+ (instancetype)showTipMessageInView:(NSString *)message timer:(int)aTimer;
//showActivity
+ (instancetype)showActivityMessageInWindow:(NSString*)message;
+ (instancetype)showActivityMessageInView:(NSString*)message;
//showState
+ (void)showSuccessMessage:(NSString *)Message;
+ (void)showErrorMessage:(NSString *)Message;
+ (void)showInfoMessage:(NSString *)Message;
+ (void)showWarnMessage:(NSString *)Message;
+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow;
//just hide Acivity
+ (void)hideHUD;
+ (UIViewController *)getCurrentVC;
@end
