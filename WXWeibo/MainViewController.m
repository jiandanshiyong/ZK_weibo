//
//  MainViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//


#import "MainViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "UIFactory.h"
#import "ThemeManager.h"
#import "ThemeButton.h"
#import "AppDelegate.h"
#import "UserViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //tabItem选中的颜色
        self.tabBar.tintColor = [UIColor whiteColor];
        self.tabBar.translucent = YES;
        self.tabBar.barStyle = UIBarStyleBlack;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
     [self loadThemeImage];
    
    [self _initViewController];//初始化子控制器
    
//    self.tabBar.hidden=YES;
    [self _initTabbarView]; //自定义一个底部tabBar
    
    //每60秒请求新微博未读数
    [NSTimer scheduledTimerWithTimeInterval:360 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showBadge:(BOOL)show{
    _badgeView.hidden = !show;
}

- (void)showTabBar:(BOOL)show{
    
    [UIView animateWithDuration:0.35 animations:^{
        if (show) {
            _tabbarView.left =0;
        } else {
            _tabbarView.left =-ScreenWidth;
        }
    }];
    
    [self _resizeView:show];
}



#pragma mark - UI

- (void)_resizeView:(BOOL)showTabbar{

}


//初始化子控制器
- (void)_initViewController {
    _homeCtrl = [[HomeViewController alloc] init];
    MessageViewController *message = [[MessageViewController alloc] init];
//    ProfileViewController *profile = [[ProfileViewController alloc] init];
    UserViewController *profile = [[UserViewController alloc] init];
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    MoreViewController *more = [[MoreViewController alloc] init];
    
    profile.showLoginUser =YES; //当前登录用户信息
    
    NSArray *views = @[_homeCtrl,message,profile,discover,more];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *viewController in views) {
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:nav];
        [nav release];
        
        nav.delegate =self;
        
    }
    
    self.viewControllers = viewControllers;
}

//创建底部自定义tabBar
- (void)_initTabbarView {
    
//    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth, 49)];
////    _tabbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
//    UIImageView *imageView =[UIFactory createImageView:@"tabbar_background.png"];
//    imageView.frame =_tabbarView.bounds;
//    [_tabbarView addSubview:imageView];
    
//    [self.view addSubview:_tabbarView];
    
    NSArray *backgroud = @[@"tabbar_home.png",@"tabbar_message_center.png",@"tabbar_profile.png",@"tabbar_discover.png",@"tabbar_more.png"];
    
    NSArray *heightBackground = @[@"tabbar_home_highlighted.png",@"tabbar_message_center_highlighted.png",@"tabbar_profile_highlighted.png",@"tabbar_discover_highlighted.png",@"tabbar_more_highlighted.png"];
    
    for (int i=0; i<backgroud.count; i++) {
        NSString *backImage = backgroud[i];
        NSString *heightImage = heightBackground[i];
        
//        ThemeButton *button =[[ThemeButton alloc] initWithImage:backImage highlighted:heightImage];
        UIButton *button =[UIFactory createButton:backImage highlighted:heightImage];
        button.showsTouchWhenHighlighted=YES;
        button.frame  =CGRectMake((ScreenWidth/5-30)/2+(ScreenWidth/5)*i, (49-30)/2-2, 30, 30);
        button.tag =i;
        
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
        
    }
    
//    _sliderView =[UIFactory createImageView:@"tabbar_slider.png"];
//    _sliderView.backgroundColor =[UIColor clearColor];
//    _sliderView.frame =CGRectMake((64-15)/2, 5, 15, 44);
//    [_tabbarView addSubview:_sliderView];
}

- (void)refreshUnReadView:(NSDictionary *)result{
    //新微博未读数
    NSNumber *status =[result objectForKey:@"status"];
   
    if (_badgeView ==nil) {
        _badgeView =[UIFactory createImageView:@"main_badge.png"];
        _badgeView.frame =CGRectMake(64-25, 5, 20, 20);
        [_tabbarView addSubview:_badgeView];
        
        UILabel *badgeLabel =[[UILabel alloc] initWithFrame:_badgeView.bounds];
        badgeLabel.textAlignment =NSTextAlignmentCenter;
        badgeLabel.backgroundColor =[UIColor clearColor];
        badgeLabel.font =[UIFont systemFontOfSize:13.0f];
        badgeLabel.textColor =[UIColor purpleColor];
        badgeLabel.tag =100;
        [_badgeView addSubview:badgeLabel];
        [badgeLabel release];
    }
    
    int n =[status intValue];
    if (n >0) {
        if (n>99) {
            n =99;
        }
        UILabel *badgeLabel =(UILabel *)[_badgeView viewWithTag:100];
        badgeLabel.text =[NSString stringWithFormat:@"%d", n];
        _badgeView.hidden =NO;
    }else {
        _badgeView.hidden =YES;
    }

}

#pragma mark - data
//新微博未读数 请求
- (void)loadUnReadData{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegate.sinaweibo;
    
    [sinaweibo requestWithURL:@"remind/unread_count.json"
                       params:nil
                   httpMethod:@"GET"
                        block:^(NSDictionary *result) {
                            [self refreshUnReadView:result];
                        }];
}

- (void)timerAction:(NSTimer *)timer{
    [self loadUnReadData];
}

#pragma mark - action

- (void)selectedTab:(UIButton *)button {
  
    [UIView animateWithDuration:0.2 animations:^{
        _sliderView.frame = CGRectMake((ScreenWidth/5-30)/2+(ScreenWidth/5)*button.tag, 5, 15, 44) ;
    }];
    
    //判断是否是重复点击tab按钮
    if (button.tag ==self.selectedIndex && button.tag ==0) {
//        UINavigationController *homeNav =[self.viewControllers objectAtIndex:0];
//        HomeViewController *homeViewController =[homeNav.viewControllers objectAtIndex:0];
        
        [_homeCtrl refreshWeibo];
    }
    
    self.selectedIndex = button.tag;
    
}

#pragma mark - NSNotification actions
- (void)themeNotification:(NSNotification *)notification{
    [self loadThemeImage];
}

- (void)loadThemeImage{
    if ([self.tabBar respondsToSelector:@selector(setTintColor:)]) {
        UIImage *image = [[ThemeManager shareInstance] getThemeImage: @"tabbar_background.png"];
        [self.tabBar setBarTintColor:[UIColor colorWithPatternImage:image]];
        self.tabBar.translucent = YES; // 导航栏透明
        
       UIColor *color =[[ThemeManager shareInstance] getColorWithName:kThemeListLabel];
       self.tabBar.tintColor = color;
        
    }else {
        //调用setNeedsDisplay方法会让绚烂引擎异步调用drawRect方法
        [self.tabBar setNeedsDisplay];
    }
}


#pragma mark - SinaWeibo delegate
//登陆成功之后
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
   
    //保存认证的数据到本地
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_homeCtrl loadWeiboData];
}
//退出
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo {
    //移除认证的数据
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
//放弃登陆
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo {
    NSLog(@"sinaweiboLogInDidCancel");    
}
//登录失败
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}
//token超时 退出
- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    //移除认证的数据
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - UINavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //导航控制器 子控制器的个数
    int count =(int *)navigationController.viewControllers.count;
    
    if (count ==2) {   //隐藏下方tabbar栏
        [self showTabBar:NO];
    }
    else if (count ==1) {
        [self showTabBar:YES];
    }
}


@end
