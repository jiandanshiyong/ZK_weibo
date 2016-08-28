//
//  FriendshipsCell.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/20.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import "FriendshipsCell.h"
#import "UserGridView.h"
#import "UserModel.h"

@implementation FriendshipsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return  self;
}

- (void)initViews{
    for (int i=0; i<3; i++) {
        UserGridView *gridView =[[UserGridView alloc] initWithFrame:CGRectZero];
        gridView.tag =2013+i;
        [self.contentView addSubview:gridView];
        [gridView release];
    }
}

//解决最后一行不足三个的问题
- (void)setData:(NSArray *)data{
    if (_data != data) {
        [_data release];
        _data =[data retain];
    }
    
     for (int i =0; i<3; i++) {
         int tag =2013+i;
         UserGridView *gridView =(UserGridView *)[self.contentView viewWithTag:tag];
         gridView.hidden =YES;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i =0; i<self.data.count; i++) {
        UserModel *userModel =[self.data objectAtIndex:i];
        int tag =2013+i;
        UserGridView *gridView =(UserGridView *)[self.contentView viewWithTag:tag];
        gridView.frame =CGRectMake(100*i+12, 10, 96, 96);
        gridView.userModel =userModel;
        gridView.hidden =NO;
        
        //让gridView 异步调用 layoutSubviews
        [gridView setNeedsLayout];
    }

}


@end
