//
//  MessageViewController.h
//  WXWeibo
//  消息首页控制器

//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@interface MessageViewController : BaseViewController<UITableViewEventDelegate>{

    WeiboTableView *_weiboTable;
}

@end
