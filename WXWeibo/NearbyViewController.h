//
//  NearbyViewController.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^SelectDoneBlock)(NSDictionary *);

@interface NearbyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property(nonatomic, retain)NSArray *data;
@property(nonatomic, copy)SelectDoneBlock selectBlock;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
