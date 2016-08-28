//
//  BaseViewController.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "AppDelegate.h"

@class MBProgressHUD;
@interface BaseViewController : UIViewController{
    UIView *_loadView;
    UIWindow *_tipWindow;
}


@property(nonatomic, assign)BOOL isBackButton;
@property(nonatomic, assign)BOOL isCacelButton;
@property(nonatomic, retain)MBProgressHUD *hud;

- (SinaWeibo *)sinaweibo;
- (AppDelegate *)appDelegate;

//提示加载效果
- (void)showLoading:(BOOL)show;
- (void)showHUD:(NSString *)title isDim:(BOOL *)isDim;
- (void)showHUDComplete:(NSString *)title;//完成
- (void)hidHUD;

//状态栏上的提示
- (void)showStatusTips:(BOOL)show title:(NSString *)title;

@end
