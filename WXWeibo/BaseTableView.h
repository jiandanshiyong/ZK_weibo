//
//  BaseTableView.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class BaseTableView;
@protocol UITableViewEventDelegate <NSObject>
@optional
//下拉
- (void)pullDown:(BaseTableView *)tableView;
//上拉
- (void)pullUp:(BaseTableView *)tableView;
//选中一个cell
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BaseTableView : UITableView<EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    UIButton *_moreButton; //上拉刷新按钮
}

@property(nonatomic, assign)BOOL refreshHeader; //是否需要下拉效果
@property(nonatomic, retain)NSArray *data;       //为tableView提供数据

@property(nonatomic, assign)id<UITableViewEventDelegate> eventDelegate;

@property(nonatomic, assign)BOOL isMore; //是否有下一页

//停止加载，弹回下拉
- (void)doneLoadingTableViewData;

- (void)refreshData;

@end
