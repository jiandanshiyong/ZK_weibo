//
//  FriendshipViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/20.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import "FriendshipViewController.h"
#import "DataService.h"
#import "UserModel.h"

@interface FriendshipViewController ()

@end

@implementation FriendshipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data =[NSMutableArray array];
    self.friendshipTableView.eventDelegate =self;
    
    if (self.shipType ==Fans) {
        self.title= @"粉丝数";
        [self loadData:URL_FOLLOWERS];
    }
    else if (self.shipType == Attention){
        self.title =@"关注数";
        [self loadData:URL_FRIENDS];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //弹回下拉
    [self.friendshipTableView doneLoadingTableViewData];
}

//加载粉丝数
- (void)loadData:(NSString *)url{
    if (self.userId.length ==0) {
        NSLog(@"用户ID为空");
        return;
    }
    NSMutableDictionary *params =[NSMutableDictionary dictionaryWithObject:self.userId forKey:@"uid"];
    
    
    //返回结果的游标，下一页用返回值里的next_cursor，上一页用previous_cursor，默认为0。
    if(self.cursor.length >0){
        [params setObject:self.cursor forKey:@"cursor"];
    }
    
    [DataService requestWithURL:url params:params httpMethod:@"GET" completeBlock:^(id result) {
        [self loadDataFinish:result];
    }];

}

- (void)loadDataFinish:(NSDictionary *)result{
    [super showLoading:NO];
    NSArray *userArray =[result objectForKey:@"users"];
    
    /*
     
     [
        ["用户1","用户2","用户3"],
        ["用户1","用户2","用户3"],
        ["用户1","用户2"],
        ...
     ]
    */
    NSMutableArray *array2D=nil;
    for (int i=0; i<userArray.count; i++) {
        array2D =[self.data lastObject];
        
        //每次判断最后一个数组是否填满数据
        if (array2D.count ==3 || array2D ==nil) {
            array2D =[NSMutableArray arrayWithCapacity:3];
            [self.data addObject:array2D];
        }
        
        NSDictionary *userDic =userArray[i];
        UserModel *userModel =[[UserModel alloc] initWithDataDic:userDic];
        [array2D addObject:userModel];
    }
    
    self.friendshipTableView.data =_data;
    [self.friendshipTableView reloadData];
    
    
    
    //刷新UI
    if (userArray.count <2) {
        self.friendshipTableView.isMore =NO;
    } else{
        self.friendshipTableView.isMore =YES;
    }
    
    //下拉收起
    if (self.cursor ==nil) {
        [self.friendshipTableView doneLoadingTableViewData];
    }
    
    //记录结果的下一页游标
    self.cursor =[[result objectForKey:@"next_cursor"] stringValue];
}


#pragma mark - UITableViewEventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView{
    NSLog(@"Friendship下拉。。。");
    
    self.cursor =nil;
    [self.data removeAllObjects];
    
    if (self.shipType ==Fans) {
        [self loadData:URL_FOLLOWERS];
    }
    else if (self.shipType == Attention){
        [self loadData:URL_FRIENDS];
    }

    
}
//上拉
- (void)pullUp:(BaseTableView *)tableView{
    NSLog(@"Friendship上拉。。。");
    
    if (self.shipType ==Fans) {
        [self loadData:URL_FOLLOWERS];
    }
    else if (self.shipType == Attention){
        [self loadData:URL_FRIENDS];
    }

}


#pragma mark - Memory manager
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_friendshipTableView release];
    [super dealloc];
}

@end
