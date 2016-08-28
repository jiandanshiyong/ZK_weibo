//
//  CommentCell.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "CommentModel.h"
#import "UIUtils.h"

@implementation CommentCell

- (void)awakeFromNib {
    //头像
    _userImage =(UIImageView *)[self viewWithTag:100];
    _userImage.layer.cornerRadius =5; //圆角半径
    _userImage.layer.masksToBounds =YES; //剪切图层边界
    
    //昵称
    _userLabel =(UILabel *)[self viewWithTag:101];
    //时间
    _timeLabel =(UILabel *)[self viewWithTag:102];
    
    //评论内容
    _contentLabel =[[RTLabel alloc] initWithFrame:CGRectMake(_userImage.right+10, _userLabel.bottom+5, 240, 21)];
    _contentLabel.font =[UIFont systemFontOfSize:14.0f];
    _contentLabel.delegate =self;
    //设置链接的颜色
    _contentLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    //设置链接高亮的颜色
    _contentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self.contentView addSubview:_contentLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSString *urlStr =self.comentModel.user.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:urlStr]];
    
    //昵称
    _userLabel.text =self.comentModel.user.screen_name;
    //发布时间
    _timeLabel.text =[UIUtils fomateString:self.comentModel.created_at];
    
    //内容Labal；
    NSString *commentText =self.comentModel.text;
    commentText =[UIUtils parseLink:commentText]; //解析超链接
    _contentLabel.text =commentText;
    _contentLabel.height =_contentLabel.optimumSize.height;
}

+ (float)getCommentHeight:(CommentModel *)commnetModel{
    
    RTLabel *rt =[[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
    rt.text = commnetModel.text;
    rt.font =[UIFont systemFontOfSize:14.0f];
    return rt.optimumSize.height;
}

#pragma mark - RTLabel Delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url{
    //评论列表超链接

}


@end
