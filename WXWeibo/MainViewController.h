//
//  MainViewController.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@class HomeViewController;
@interface MainViewController : UITabBarController<SinaWeiboDelegate, UINavigationControllerDelegate> {
    UIView *_tabbarView;
    UIImageView *_sliderView; //自定义tabbar 选中某个Tab时下方的白线标识
    UIImageView *_badgeView; //上部显示刷新几条微博
    
    HomeViewController *_homeCtrl;
}

- (void)showBadge:(BOOL)show;
- (void)showTabBar:(BOOL)show;

@end
