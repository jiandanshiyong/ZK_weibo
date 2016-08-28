//
//  FriendshipTableView.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/20.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import "FriendshipTableView.h"
#import "FriendshipsCell.h"

@implementation FriendshipTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self =[super initWithFrame:frame style:style];
    if (self != nil) {
        self.separatorStyle =UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify =@"FriendshipCell";
    FriendshipsCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell =[[[FriendshipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    
    NSArray *array =[self.data objectAtIndex:indexPath.row]; //二维数组行数取值,传递一维数组
    cell.data =array;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}


@end
