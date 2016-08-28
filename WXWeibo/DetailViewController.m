//
//  DetailViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "CommentModel.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"微博正文";
    [self _initView];
    
    [self loadData];
}

- (void)_initView{
    //创建tableView头视图
    UIView *tableHeaderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    tableHeaderView.backgroundColor =[UIColor clearColor];

    //加载用户头像
    self.userImageView.layer.cornerRadius =5;
    self.userImageView.layer.masksToBounds =YES;
    NSString *userImageStr =_weiboMode.user.profile_image_url;
    [self.userImageView setImageWithURL:[NSURL URLWithString:userImageStr]];
    
    //加载用户昵称
    self.userLabel.text =_weiboMode.user.screen_name;
    
    [tableHeaderView addSubview:self.userBarView];
    tableHeaderView.height +=60;
    
    //--------------------创建微博视图--------------------
    float h = [WeiboView getWeiboViewHeight:_weiboMode isRepost:NO isDetail:YES];
    _weiboView =[[WeiboView alloc]initWithFrame:CGRectMake(10, _userBarView.bottom+10, ScreenWidth-20, h)];
    _weiboView.isDetail =YES;//微博视图是否显示在详情页面
    _weiboView.weiboModel =_weiboMode;
    
    [tableHeaderView addSubview:_weiboView];
    tableHeaderView.height +=(h+10);
    
    
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableView.eventDelegate =self;
    [tableHeaderView release];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //弹回下拉
    [self.tableView doneLoadingTableViewData];
}

- (void)loadData{
    NSString *weiboId =[_weiboMode.weiboId stringValue];
    if (weiboId.length ==0) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:weiboId forKey:@"id"];
    [self.sinaweibo requestWithURL:URL_COMMENTS_SHOW
                            params:params
                        httpMethod:@"GET"
                             block:^(NSDictionary *result) {
                                 [self loadDataFinish:result];
                             }];

}

- (void)loadDataFinish:(NSDictionary *)result{
    NSArray *array =[result objectForKey:@"comments"];
    NSMutableArray *comments =[NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        CommentModel *commentModel =[[CommentModel alloc] initWithCommentDataDic:dic];
        [comments addObject:commentModel];
        [commentModel release];
    }
    
    
    if (array.count >= 20) {
        self.tableView.isMore =YES ;
    } else {
        self.tableView.isMore =NO;
    }
    
    self.tableView.data = comments;
    self.tableView.commentDic =result; //将整个字典传给CommentTableView
    [self.tableView reloadData];
}


#pragma mark - UITableViewEventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView{
    NSLog(@"Detail下拉。。。");
    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2];
    
}
//上拉
- (void)pullUp:(BaseTableView *)tableView{
    NSLog(@"Detail上拉。。。");
    [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:2];
}
//选中一个cell
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}

#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_userImageView release];
    [_userLabel release];
    [_userBarView release];
    [super dealloc];
}
@end
