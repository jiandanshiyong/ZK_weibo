//
//  WeiboView.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/8.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@class WeiboModel;
@class ThemeImageView;

#define kWeibo_Width_List  (320-60) //微博在列表中的宽度
#define kWeibo_Width_Detail 300     //微博在详情页面的宽度


@interface WeiboView : UIView<RTLabelDelegate>{
    
    RTLabel         *_textLabel;            //微博内容
    UIImageView     *_imageView;            //微博图片
    ThemeImageView  *_repostBackgroudView;  //转发额微博视图背景
    WeiboView       *_repostView;           //转发的微博视图
    
    NSMutableString  *_parseText;
}

//微博模型对象
@property(nonatomic,retain)WeiboModel *weiboModel;

//当前的微博视图，是否是转发的
@property(nonatomic,assign)BOOL isRepost;
//微博视图是否显示在详情页面
@property(nonatomic,assign)BOOL isDetail;

//获取字体大小
+ (float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost;

//计数微博视图的高度
+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel
                     isRepost:(BOOL)isRepost
                     isDetail:(BOOL)isDetail;

@end
