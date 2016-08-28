//
//  BaseTableView.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self =[super initWithFrame:frame style:style];
    if (self) {
        [self _initView];
    }
    return self;
}

//使用xib创建
- (void)awakeFromNib{
    [self _initView];
}


- (void)_initView{
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor =[UIColor clearColor];
    
    self.dataSource =self;
    self.delegate =self;
    
    self.refreshHeader =YES;
    
    _moreButton =[[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _moreButton.backgroundColor =[UIColor clearColor];
    _moreButton.frame =CGRectMake(0, 0, ScreenWidth, 40);
    _moreButton.titleLabel.font =[UIFont systemFontOfSize:16.0f];
    [_moreButton setTitle:@"点击加载更多..." forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIActivityIndicatorView *activityView =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.tag =2016;
    activityView.frame =CGRectMake(100, 10, 20, 20);
    [activityView stopAnimating];
    [_moreButton addSubview:activityView];
    
    
    self.tableFooterView =_moreButton;
}

- (void)setRefreshHeader:(BOOL)refreshHeader{
    _refreshHeader =refreshHeader;
    
    if (_refreshHeader) {
        [self addSubview:_refreshHeaderView];
        
    } else {
        if ([_refreshHeaderView superview]) {
            [_refreshHeaderView removeFromSuperview];
        }
    }
}

- (void)refreshData{

    [_refreshHeaderView initLoading:self];
}

- (void)_startLoadMore{
    [_moreButton setTitle:@"正在加载..." forState:UIControlStateNormal];
    _moreButton.enabled =NO;
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2016];
    [activityView startAnimating];
}

- (void)_stopLoadMore{
    
    if (self.data.count >0) {
        _moreButton.hidden =NO;
        
        [_moreButton setTitle:@"点击加载更多..." forState:UIControlStateNormal];
        _moreButton.enabled =YES;
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2016];
        [activityView stopAnimating];
        
        if (!self.isMore) {
            [_moreButton setTitle:@"加载完成" forState:UIControlStateNormal];
             _moreButton.enabled =NO;
        }
        
    }else {
        _moreButton.hidden =YES;
    }
    
}

- (void)reloadData{
    [super reloadData];
    
    //停止加载
    [self _stopLoadMore];
}

#pragma mark - actions
- (void)loadMoreAction{
    if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
        [self.eventDelegate pullUp:self];
        [self _startLoadMore];
    }

}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.eventDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.eventDelegate tableView:self didSelectRowAtIndexPath:indexPath ];
    }
}

#pragma mark - 下拉的相关方法

- (void)reloadTableViewDataSource{
    _reloading = YES;
    
}
//停止加载，弹回下拉
- (void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

//滚动事件方法，滚动过程中会一直循环执行（滚动中…）
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

//拖拽操作完成事件方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    
    float offset =scrollView.contentOffset.y;
    float contentHeight =scrollView.contentSize.height;

    
//    if (offset <-30) {    //*****下拉*******
//        NSLog(@"下拉偏移量:%f",offset);
//    }
    
    if (!self.isMore) {
        return;
    }
    //当offset偏移量滑到底部时，差值是scrollView的高度
    float sub =contentHeight-offset;
    if ((scrollView.height - sub) > 20) {  //*****上拉*******
//        NSLog(@"上拉偏移量:%f",sub -scrollView.height);

        [self _startLoadMore];
        
        if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
            [self.eventDelegate pullUp:self];
        }
    }
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    //设置为“正在加载”状态
    [self reloadTableViewDataSource];
    
    //停止加载，弹回下拉
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
    if ([self.eventDelegate respondsToSelector:@selector(pullDown:)]) {
        [self.eventDelegate pullDown:self];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


@end
