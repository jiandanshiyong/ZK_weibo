//
//  UserViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/11.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoView.h"
#import "UserModel.h"
#import "UIFactory.h"
#import "NSString+URLEncoding.h"
#import "WeiboModel.h"

@interface UserViewController ()

@end

@implementation UserViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人中心";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _requests = [[NSMutableArray alloc]init];
//    self.title =@"个人资料";
    if (self.showLoginUser) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        NSString *userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        self.userId = userID;
    }
    
    
    UIButton *homeButton =[UIFactory createButtonWithBackgound:@"tabbar_home.png" backgroundHighlighted:@"tabbar_home_highlighted.png"];
    homeButton.frame =CGRectMake(0, 0, 34, 27);
    [homeButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeItem =[[UIBarButtonItem alloc]initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem =homeItem;
    
    _userInfo =[[UserInfoView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    
    self.tableView.hidden =YES;
    self.tableView.eventDelegate =self;
    [super showLoading:YES];
    
    [self loadUserData];
    [self loadWeiboData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //弹回下拉
    [self.tableView doneLoadingTableViewData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (SinaWeiboRequest *request in _requests) {
        //取消请求
        [request disconnect];
    }
}

#pragma mark - data
//加载用户资料
- (void)loadUserData{
    if (self.userName.length ==0 && self.userId.length ==0) {
        NSLog(@"error:用户为空!");
        return;
    }
    
//    NSMutableDictionary *params =[NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    NSMutableDictionary *params =[NSMutableDictionary dictionary];
    if (self.userId.length != 0) {
        [params setObject:self.userId forKey:@"uid"];
    } else {
        [params setObject:self.userName forKey:@"screen_name"];
    }
    
    SinaWeiboRequest *request=[self.sinaweibo requestWithURL:URL_USER_SHOW params:params httpMethod:@"GET" block:^(NSDictionary *result) {
               [self loadUserDataFinish:result];
        } ];
    [_requests addObject:request];

}

- (void)loadUserDataFinish:(NSDictionary *)result{
    UserModel *userModel =[[UserModel alloc] initWithDataDic:result];
    _userInfo.user =userModel;
    
    [self refreshUI];
}

//加载用户最新发表的微博列表
- (void)loadWeiboData{
    if (self.userName.length ==0 && self.userId.length ==0) {
        NSLog(@"error:用户为空!");
        return;
    }
    
    /** 必须授权才能获得用户的微博列表 **/
//    NSMutableDictionary *params =[NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    
    NSMutableDictionary *params =[NSMutableDictionary dictionary];
    if (self.userId.length != 0) {
        [params setObject:self.userId forKey:@"uid"];
    } else {
        [params setObject:self.userName forKey:@"screen_name"];
    }
    
    SinaWeiboRequest *request=[self.sinaweibo requestWithURL:URL_USER_TIMELINE params:params httpMethod:@"GET" block:^(NSDictionary *result) {
                [self loadWeiboDataFinish:result];
        } ];
    [_requests addObject:request];
}

- (void)loadWeiboDataFinish:(NSDictionary *)result{
    NSArray *status =[result objectForKey:@"statuses"];
    NSMutableArray *weibos =[NSMutableArray arrayWithCapacity:status.count];
    for (NSDictionary *dic in status) {
        WeiboModel *weibo =[[WeiboModel alloc]initWithDataDic:dic];
        [weibos addObject:weibo];
    }
    
    self.tableView.data =weibos;
    if (weibos.count >= 20) {
        self.tableView.isMore =YES;
    }else {
        self.tableView.isMore =NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)refreshUI{
    [super showLoading:NO];
    self.tableView.hidden =NO;
    self.tableView.tableHeaderView =_userInfo;
}

#pragma mark - actions
- (void)goHome{
    [self.navigationController popToRootViewControllerAnimated:YES];

}


#pragma mark - UITableViewEventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView{
    NSLog(@"UserView下拉。。。");
    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2];
    
}
//上拉
- (void)pullUp:(BaseTableView *)tableView{
    NSLog(@"UserView上拉。。。");
    [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:2];
}


#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}


@end
