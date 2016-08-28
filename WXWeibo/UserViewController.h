//
//  UserViewController.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/11.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@class UserInfoView;
@interface UserViewController : BaseViewController<UITableViewEventDelegate>{

    NSMutableArray *_requests;

}

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic, assign)BOOL showLoginUser;

@property(nonatomic, retain)UserInfoView *userInfo;
@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;

@end
