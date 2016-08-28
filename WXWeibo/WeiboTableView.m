//
//  WeiboTableView.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/9.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "DetailViewController.h"

@implementation WeiboTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self =[super initWithFrame:frame style:style];
    if (self !=nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kReloadWeiboTableNofication object:nil];
    }
    return self;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify =@"WeiboCell";
    WeiboCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell ==nil) {
        cell =[[WeiboCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    WeiboModel *weibo = self.data[indexPath.row];
    cell.weiboModel =weibo;
    
    return cell;
}

#pragma mark - 代理方法
#pragma mark 重新设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboModel *weibo = self.data[indexPath.row];
    float height =[WeiboView getWeiboViewHeight:weibo isRepost:NO isDetail:NO];
    
    height +=80;
    return height;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"选中cell");
    
    WeiboModel *weibo =self.data[indexPath.row];
    
    DetailViewController *detail =[[DetailViewController alloc]init];
    detail.weiboMode =weibo;
    [self.viewController.navigationController pushViewController:detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中cell
}


@end
