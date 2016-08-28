//
//  BaseViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseViewController.h"
#import "UIFactory.h"
#import "MBProgressHUD.h"


@interface BaseViewController ()

@end

@implementation BaseViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton =YES;
        self.isCacelButton =NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //重新定义返回按钮
    NSArray *viewControllers =self.navigationController.viewControllers;
    if (viewControllers.count >1 && self.isBackButton) {
        UIButton *button =[UIFactory createButton:@"navigationbar_back.png" highlighted:@"navigationbar_back_highlighted.png"];
        button.showsTouchWhenHighlighted =YES;
        button.frame = CGRectMake(0, 0, 24, 24);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem =[[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem =[backItem autorelease];
    }
    
    //模态视图返回按钮
    if (self.isCacelButton) {
        UIButton *cancelButton =[UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"取消" target:self action:@selector(cancelAction)];
        UIBarButtonItem *cancelItem =[[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        self.navigationItem.leftBarButtonItem =cancelItem;

    }
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//override
//设置导航栏上的标题
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    titleLabel.textColor = [UIColor blackColor];
    UILabel *titleLabel =[UIFactory createLabel:kNavigationBarTitleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = [titleLabel autorelease];
}

- (AppDelegate *)appDelegate{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

- (SinaWeibo *)sinaweibo {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegate.sinaweibo;
    return sinaweibo;
}

#pragma mark - loading
- (void)showLoading:(BOOL)show{
    if (_loadView == nil) {
        _loadView =[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2-80, ScreenWidth, 320)];
        
        //loading视图
        UIActivityIndicatorView *activityView =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        
        //正在加载的label
        UILabel *loadLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        loadLabel.backgroundColor =[UIColor clearColor];
        loadLabel.text =@"正在加载...";
        loadLabel.font =[UIFont systemFontOfSize:16.0];
        loadLabel.textColor =[UIColor blackColor];
        [loadLabel sizeToFit];
        
        loadLabel.left =(320-loadLabel.width)/2;
        activityView.right =loadLabel.left-5;
        
        [_loadView addSubview:loadLabel];
        [_loadView addSubview:activityView];
        [activityView release];
    }
    if (show) {
        if (![_loadView superview]) {
            [self.view addSubview:_loadView];
        }
    } else {
        [_loadView removeFromSuperview];
    }

}

- (void)showHUD:(NSString *)title isDim:(BOOL *)isDim{
    self.hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground =isDim; //是否有背景
    self.hud.labelText =title; //下方是否有文字
    
}

//可以自定义图片,添加文字的HUD
- (void)showHUDComplete:(NSString *)title{
    self.hud.customView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode =MBProgressHUDModeCustomView;
    if (title.length >0) {
        self.hud.labelText =title;
    }
    [self.hud hide:YES  afterDelay:1];
}

- (void)hidHUD{
    [self.hud hide:YES ];
}

//状态栏上的提示
- (void)showStatusTips:(BOOL)show title:(NSString *)title{
    if (_tipWindow ==nil) {
        _tipWindow =[[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, 20)];
        _tipWindow.windowLevel =UIWindowLevelStatusBar;
        _tipWindow.backgroundColor =[UIColor blackColor];
        
        UILabel *tipLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        tipLabel.textAlignment =NSTextAlignmentCenter;
        tipLabel.font =[UIFont systemFontOfSize:13.0f];
        tipLabel.textColor =[UIColor whiteColor];
        tipLabel.backgroundColor =[UIColor clearColor];
        tipLabel.tag =2016;
        [_tipWindow addSubview:tipLabel];
        
        UIImageView *progress =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"queue_statusbar_progress.png"]];
        progress.frame =CGRectMake(0, 20-6, 100, 6);
        progress.tag =2015;
        [_tipWindow addSubview:progress];
    }
    
    UILabel *tipLabel =(UILabel *)[_tipWindow viewWithTag:2016];
    UIImageView *prograss =(UIImageView *)[_tipWindow viewWithTag:2015];
    if (show) {
        tipLabel.text =title;
        _tipWindow.hidden =NO;
        
        prograss.left =0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2];
        [UIView setAnimationRepeatCount:100];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear]; //匀速移动
        prograss.left =ScreenWidth;
        [UIView commitAnimations];
        
    } else {
        prograss.hidden =YES;
        tipLabel.text =title;
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:1.5];
    }
}

- (void)removeTipWindow{
    _tipWindow.hidden =YES;
    
    [_tipWindow release];
    _tipWindow =nil;
}


@end
