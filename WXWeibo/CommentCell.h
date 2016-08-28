//
//  CommentCell.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@class CommentModel;
@interface CommentCell : UITableViewCell<RTLabelDelegate>{
    UIImageView *_userImage;
    UILabel *_userLabel;
    UILabel *_timeLabel;
    RTLabel *_contentLabel;

}

@property(nonatomic, retain)CommentModel *comentModel;

//计算评论单元格的高度
+ (float)getCommentHeight:(CommentModel *)commnetModel;
@end
