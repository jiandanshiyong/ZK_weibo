//
//  CommentModel.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/10.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "WeiboModel.h"
#import "UserModel.h"
/*
 created_at	string	评论创建时间
 id	int64	评论的ID
 text	string	评论的内容
 source	string	评论的来源
 user	object	评论作者的用户信息字段 详细
 mid	string	评论的MID
 idstr	string	字符串型的评论ID
 status	object	评论的微博信息字段 详细
 
 */

@interface CommentModel : NSObject

@property(nonatomic, copy)NSString   *created_at;
@property(nonatomic, retain)NSNumber *weiboId;
@property(nonatomic, copy)NSString   *text;
@property(nonatomic, copy)NSString   *source;
@property(nonatomic, retain)UserModel *user;
@property(nonatomic, copy)NSString   *mid;
@property(nonatomic, copy)NSString   *idstr;
@property(nonatomic, retain)WeiboModel *weibo;

-(id)initWithCommentDataDic:(NSDictionary*)data;

@end
