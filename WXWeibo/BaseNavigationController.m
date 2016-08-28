//
//  BaseNavigationController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.navigationBar.barStyle = UIBarStyleBlack;
//        self.navigationBar.translucent = YES; // 导航栏透明
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}
- (void)dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self loadThemeImage];
    
    //添加右滑 返回手势
    UISwipeGestureRecognizer *swipGesture =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
    swipGesture.direction =UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipGesture];
    [swipGesture release];

}

- (void)swipAction:(UISwipeGestureRecognizer *)gesture{
    if (self.viewControllers.count >1) {
        if (gesture.direction ==UISwipeGestureRecognizerDirectionRight) {
            [self popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - NSNotification actions
- (void)themeNotification:(NSNotification *)notification{
    [self loadThemeImage];
}

- (void)loadThemeImage{
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        //设置顶部导航背景
//        UIImage *image = [[ThemeManager shareInstance] getThemeImage: @"tabbar_background.png"];
//        [self.navigationBar setBarTintColor:[UIColor colorWithPatternImage:image]];
        [self.navigationBar setBarTintColor:[UIColor blackColor]];
        
        //设置navigationbar的barItem的颜色
        UIColor *color =[[ThemeManager shareInstance] getColorWithName:kThemeListLabel];
        self.navigationBar.tintColor = color;

    }else {
        //调用setNeedsDisplay方法会让绚烂引擎异步调用drawRect方法
        [self.navigationBar setNeedsDisplay];
    }
}

@end
