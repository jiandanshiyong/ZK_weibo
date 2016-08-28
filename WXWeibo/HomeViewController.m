//
//  HomeViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "HomeViewController.h"
#import "WeiboModel.h"
#import "UIFactory.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MainViewController.h"
#import "DetailViewController.h"

@interface HomeViewController (){
    ThemeImageView *barView;

}

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"微博";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //绑定按钮
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定账号" style:UIBarButtonItemStyleBordered target:self action:@selector(bindAction:)];
    self.navigationItem.rightBarButtonItem = [bindItem autorelease];
    
    //注销按钮
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction:)];
    self.navigationItem.leftBarButtonItem = [logoutItem autorelease];
    
    _tableView =[[WeiboTableView alloc]initWithFrame:CGRectMake(0, 20+44, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.eventDelegate =self;
    _tableView.hidden =YES; //数据加载完成以前 隐藏
    [self.view addSubview:_tableView];
    
    //判断是否认证
    if (self.sinaweibo.isAuthValid) {
        //加载微博列表数据
        [self loadWeiboData];
    } else {
        //登陆
        [self.sinaweibo logIn];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //开启左右滑动
    [self.appDelegate.menuCtrl setEnableGesture:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //弹回下拉
    [self.tableView doneLoadingTableViewData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    //禁用左右滑动
    [self.appDelegate.menuCtrl setEnableGesture:NO];
}


#pragma mark - actions
- (void)bindAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logIn];
}

- (void)logoutAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logOut];
    
//    [self.sinaweibo logIn];
}

#pragma mark - UI
//显示刷新的微博数量
- (void)showNewWeiboCount:(int)count{
    if (barView == nil) {
        barView =[[UIFactory createImageView:@"timeline_new_status_background.png"] retain];
        UIImage *image =[barView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        barView.image =image;
        barView.leftCapWidth =5;
        barView.topCapHeight =5;
        barView.frame =CGRectMake(5, -40, ScreenWidth-10, 40);
        [self.view addSubview:barView];
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectZero];
        label.tag =2016;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor =[UIColor whiteColor];
        label.backgroundColor =[UIColor clearColor];
        [barView addSubview:label];
        [label release];
    }
    
    if (count >0) {
        UILabel *label =(UILabel *)[barView viewWithTag:2016];
        label.text =[NSString stringWithFormat:@"%d条新微博",count];
        [label sizeToFit];
        label.origin =CGPointMake((barView.width-label.width)/2, (barView.height-label.height)/2);
        
        [UIView animateWithDuration:0.6 animations:^{
            barView.top =5;
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:1];
                [UIView setAnimationDuration:0.6];
                barView.top =-40;
                [UIView commitAnimations];
            }
        }];
        
       //播放提示声音
        NSString *filePath =[[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundId);
        AudioServicesPlaySystemSound(soundId);
    }
    
    //隐藏未读图标
    MainViewController *mainCtrl=(MainViewController *)self.tabBarController;
    [mainCtrl showBadge:NO];
}


#pragma mark - load Data
- (void)loadWeiboData {
    [super showLoading:YES]; //显示网络请求loading提示
    
    /*
     * count: 单页返回的记录条数，最大不超过100， 默认20
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    [self.sinaweibo requestWithURL:URL_HOME_TIMELINE
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
    
}

//下拉加载最新微博
- (void)pullDownData{
    if (self.topWeiboId.length ==0) {
        NSLog(@"微博最大ID为空");
        return;
    }
    
    /*
     * since_id:若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0。
     * count: 单页返回的记录条数，默认为50。
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",self.topWeiboId,@"since_id", nil];
    [self.sinaweibo requestWithURL:URL_HOME_TIMELINE
                            params:params
                        httpMethod:@"GET"
                          block:^(id result) {
                              [self pullDownDataFinish:result];
                          }];
}

- (void)pullDownDataFinish: (id)result{
    NSArray *status =[result objectForKey:@"statuses"];
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:status.count];
    for (NSDictionary *statusDic in status) {
        WeiboModel *weibo =[[WeiboModel alloc] initWithDataDic:statusDic];
        [array addObject:weibo];
        [weibo release];
    }
    
    //更新top Id
    if(array.count >0){
        WeiboModel *topWeibo=[array objectAtIndex:0];
        self.topWeiboId =[topWeibo.weiboId stringValue];

    }
    
    [array addObjectsFromArray:self.weibos];
    self.weibos =array;
    self.tableView.data =array;
    
    //刷新UI
    [self.tableView reloadData];
    //弹回下拉
    [self.tableView doneLoadingTableViewData];
    
    //显示更新的数目
    int updateCount =(int *)[status count];
//    NSLog(@"下拉更新条数：%d",updateCount);
    [self showNewWeiboCount:updateCount];
}

//上拉加载最新微博
- (void)pullUpData{
    if (self.lastWeiboId.length ==0) {
        NSLog(@"微博最小ID为空");
        return;
    }
    
    /*
     * max_id:若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
     * count: 单页返回的记录条数，默认为50。
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",self.lastWeiboId,@"max_id", nil];
    [self.sinaweibo requestWithURL:URL_HOME_TIMELINE
                            params:params
                        httpMethod:@"GET"
                             block:^(id result) {
                                 [self pullUpDataFinish:result];
                             }];
}

- (void)pullUpDataFinish: (id)result{
    NSArray *status =[result objectForKey:@"statuses"];
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:status.count];
    for (NSDictionary *statusDic in status) {
        WeiboModel *weibo =[[WeiboModel alloc] initWithDataDic:statusDic];
        [array addObject:weibo];
        [weibo release];
    }
    
    //更新last Id
    if(array.count >0){
        WeiboModel *lastWeibo=[array lastObject];
        self.lastWeiboId =[lastWeibo.weiboId stringValue];
        
        [array removeObjectAtIndex:0];
    }
    
    [self.weibos addObjectsFromArray:array];
    
    if (status.count >= 20) {
        self.tableView.isMore =YES ;
    } else {
        self.tableView.isMore =NO;
    }
    
    self.tableView.data =self.weibos;
    [self.tableView reloadData];

}

- (void)refreshWeibo{
    [self.tableView refreshData]; //UI显示下拉
    self.tableView.hidden =NO;
    [self pullDownData]; //取数据
}


#pragma mark - SinaWeiboRequest delegate
//网络加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"网络加载失败:%@",error);
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    [super showLoading:NO]; //隐藏网络请求loading提示
    _tableView.hidden =NO;//数据加载完成以后 显示
    
    NSArray *status =[result objectForKey:@"statuses"];
    NSMutableArray *weibos =[NSMutableArray arrayWithCapacity:status.count];
    for (NSDictionary *statusDic in status) {
       WeiboModel *weibo =[[WeiboModel alloc] initWithDataDic:statusDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    self.tableView.data =weibos;
    self.weibos =weibos;
    
    if (weibos.count >0) {
        WeiboModel *topWeibo=[weibos objectAtIndex:0];
        self.topWeiboId =[topWeibo.weiboId stringValue];
        
        WeiboModel *lastWeibo=[weibos lastObject];
        self.lastWeiboId =[lastWeibo.weiboId stringValue];
    }
    
    if (status.count >= 20) {
        self.tableView.isMore =YES ;
    } else {
        self.tableView.isMore =NO;
    }
    
    //刷新tableView
    [self.tableView reloadData];
}

#pragma mark - BaseTableView EventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView{
//    NSLog(@"下拉更新网络数据");
    [self pullDownData];
}
//上拉
- (void)pullUp:(BaseTableView *)tableView{
//    NSLog(@"上拉更新网络数据");
    [self pullUpData];
    
}



#pragma mark - Memery Manager
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    
    [super dealloc];
}



@end
