//
//  BrowModeViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/11.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BrowModeViewController.h"

@interface BrowModeViewController ()

@end

@implementation BrowModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"图片浏览模式";
    
    UITableView *tabelView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tabelView.dataSource =self;
    tabelView.delegate =self;
    
    [self.view addSubview:tabelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    if (indexPath.row ==0) {
        cell.textLabel.text =@"大图";
        cell.detailTextLabel.text =@"所有网络加载大图";
    }
    else if (indexPath.row ==1) {
        cell.textLabel.text =@"小图";
        cell.detailTextLabel.text =@"所有网络加载小图";
    }
    
    return cell;
}

#pragma mark - UITableViewDelete
//切换主题
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int mode =-1;
    if (indexPath.row ==0) {
        mode =LargeBrowMode; //大图
    }
    else if (indexPath.row ==1) {
        mode =SmallBrowMode; //小图
    }
   
    //保存浏览模式到本地
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kBrowMode];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
    
    //传参，并通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNofication object:nil];
    
//    //刷新列表
//    [tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
