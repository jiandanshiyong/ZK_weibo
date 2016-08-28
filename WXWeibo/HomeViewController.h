//
//  HomeViewController.h
//  WXWeibo
//  首页控制器

//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@interface HomeViewController : BaseViewController<SinaWeiboRequestDelegate,UITableViewEventDelegate>

@property (retain, nonatomic)WeiboTableView *tableView;

@property(nonatomic, copy)NSString *topWeiboId; //标记每次加载完成后最大的ID
@property(nonatomic, copy)NSString *lastWeiboId; 

@property(nonatomic, retain)NSMutableArray *weibos;

- (void)refreshWeibo;//点击tabBar下拉

- (void)loadWeiboData;

@end
