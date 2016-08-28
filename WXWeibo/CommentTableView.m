//
//  CommentTableView.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"
#import "CommentModel.h"

@implementation CommentTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self =[super initWithFrame:frame style:style];
    if (self) {
        
    }
    return self;
}

#pragma mark - 数据源方法 重写
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify =@"commentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell ==nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil]
               lastObject];
    }
    
    CommentModel *commentModel = self.data[indexPath.row];
    cell.comentModel =commentModel;
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *commentModel =self.data[indexPath.row];
    float height =[CommentCell getCommentHeight:commentModel];
    return height+40;
}

//评论列表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    view.backgroundColor =[UIColor whiteColor];
    
    UILabel *commentCount = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    commentCount.backgroundColor =[UIColor clearColor];
    commentCount.font =[UIFont systemFontOfSize:16.0f];
    commentCount.textColor =[UIColor blueColor];
    
    NSNumber *total =[self.commentDic objectForKey:@"total_number"];
    commentCount.text =[NSString stringWithFormat:@"评论:%@",total];
    [view addSubview:commentCount];
    [commentCount release];
    
    UIImageView *separeView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 39, tableView.width, 1)];
    separeView.image =[UIImage imageNamed:@"userinfo_header_separator.png"];
    [view addSubview:separeView];
    [separeView release];
    
    return [view autorelease];
}
//评论列表头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//
//}



@end
