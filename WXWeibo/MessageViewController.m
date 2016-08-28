//
//  MessageViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "MessageViewController.h"
#import "WXFaceView.h"
#import "WXFaceScrollView.h"
#import "UIFactory.h"
#import "DataService.h"
#import "WeiboModel.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"消息";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initViews];
    [self loadAtWeiboData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //弹回下拉
    [_weiboTable doneLoadingTableViewData];
}

- (void)initViews{
    
    _weiboTable =[[WeiboTableView alloc]initWithFrame:CGRectMake(0, 20+44, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _weiboTable.eventDelegate =self;
    _weiboTable.hidden =YES;
    [self.view addSubview:_weiboTable];
    
    NSArray *messageButtons =[NSArray arrayWithObjects:
                              @"navigationbar_mentions.png",
                              @"navigationbar_comments.png",
                              @"navigationbar_messages.png",
                              @"navigationbar_notice.png",
                              nil];
    UIView *titleView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    for (int i=0; i<messageButtons.count; i++) {
        NSString *imageName = [messageButtons objectAtIndex:i];
        UIButton *button =[UIFactory createButton:imageName highlighted:imageName];
        button.showsTouchWhenHighlighted =YES;
        button.frame =CGRectMake(50*i+20, 10, 22, 22);
        [button addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag =100+i;
        [titleView addSubview:button];
    }
    
    self.navigationItem.titleView =titleView;
}

- (void)messageAction:(UIButton *)button{
    int tag =(int)button.tag;
    if (tag ==100) {
       //@我的微博
    }
    else if(tag == 101 ){
        //评论
        
    }
    else if(tag == 102 ){
        //私信
    }
    else if(tag == 103 ){
        //系统消息
    }
}

- (void)loadAtWeiboData{
    [super showLoading:YES];
    
    [DataService requestWithURL:URL_MENTIONS params:nil httpMethod:@"GET" completeBlock:^(id result) {
        [self loadAtWeiboFinish:result];
     }];

}

- (void)loadAtWeiboFinish:(NSDictionary *)result{
    NSArray *status =[result objectForKey:@"statuses"];
    NSMutableArray *weibos =[NSMutableArray arrayWithCapacity:status.count];
    for (NSDictionary *statusDic in status) {
        WeiboModel *weibo =[[WeiboModel alloc] initWithDataDic:statusDic];
        [weibos addObject:weibo];
        [weibo release];
    }
   
    //刷新UI
    [super showLoading:NO];
    _weiboTable.hidden= NO;
    _weiboTable.data =weibos;
    [_weiboTable reloadData];
}

#pragma mark - UITableViewEventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView{
    NSLog(@"Message下拉。。。");
    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2];
    
}
//上拉
- (void)pullUp:(BaseTableView *)tableView{
    NSLog(@"Message上拉。。。");
    [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:2];
    
}


#pragma  mark - Memory  Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
