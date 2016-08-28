//
//  FriendshipViewController.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/20.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendshipTableView.h"

//typedef enum{
//    Attention,  //关注列表
//    Fans        //粉丝列表
//
//} FriendshipsType;

typedef NS_ENUM(NSInteger, FriendshipsType) {
    Attention = 100,  //关注列表
    Fans              //粉丝列表
};

@interface FriendshipViewController : BaseViewController<UITableViewEventDelegate>

@property(nonatomic, copy)NSString *userId;
@property(nonatomic, retain)NSMutableArray *data;

//下一页的游标值
@property(nonatomic, copy)NSString *cursor;

@property(nonatomic, assign)FriendshipsType shipType;

@property (retain, nonatomic) IBOutlet FriendshipTableView *friendshipTableView;


@end
