//
//  DetailViewController.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentTableView.h"

@class WeiboModel;
@class WeiboView;
@interface DetailViewController : BaseViewController<UITableViewEventDelegate>{
    WeiboView *_weiboView;
    
}

@property(nonatomic, retain)WeiboModel *weiboMode;

@property (retain, nonatomic) IBOutlet CommentTableView *tableView;

@property (retain, nonatomic) IBOutlet UIView *userBarView;
@property (retain, nonatomic) IBOutlet UIImageView *userImageView;
@property (retain, nonatomic) IBOutlet UILabel *userLabel;

@end
