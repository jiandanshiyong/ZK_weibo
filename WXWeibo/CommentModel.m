//
//  CommentModel.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/10.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

/*
- (void)setAttributes:(NSDictionary *)dataDic {
    //将字典数据根据映射关系填充到当前对象的属性上。
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        self.user = user;
        [user release];
    }
    
    NSDictionary *retweetDic = [dataDic objectForKey:@"status"];
    if (retweetDic != nil) {
        WeiboModel *relWeibo = [[WeiboModel alloc] initWithDataDic:retweetDic];
        self.weibo = relWeibo;
        [relWeibo release];
    }
    
}
*/

-(id)initWithCommentDataDic:(NSDictionary*)data{
    if (self = [super init]) {
        [self setAttributes:data];
    }
    return self;
}


- (void)_initWithCmtDic:(NSDictionary *)dataDic{
    self.created_at = [dataDic objectForKey:@"created_at"];
    self.weiboId    = [dataDic objectForKey:@"id"];
    self.text       = [dataDic objectForKey:@"text"];
    self.source     = [dataDic objectForKey:@"source"];
    self.mid        = [dataDic objectForKey:@"mid"];
    self.idstr      = [dataDic objectForKey:@"idstr"];
}

- (void)setAttributes:(NSDictionary *)dataDic {
    
    [self _initWithCmtDic:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        self.user = user;
    }
    
    NSDictionary *statusDic = [dataDic objectForKey:@"status"];
    if (statusDic != nil) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statusDic];
        self.weibo = weibo;
    }
    
}

@end
