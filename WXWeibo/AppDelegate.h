//
//  AppDelegate.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
#import "MainViewController.h"

@class SinaWeibo;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,retain)SinaWeibo *sinaweibo;
@property(nonatomic,retain)MainViewController *mainCtrl;

@property(nonatomic, retain)DDMenuController *menuCtrl;

@end
