//
//  ThemeViewController.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/7.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseViewController.h"

@interface ThemeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
