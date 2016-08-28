//
//  CONSTS.h
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#ifndef WXWeibo_CONSTS_h
#define WXWeibo_CONSTS_h

#endif

//weibo OAuthu2.0
//#define kAppKey             @"891689618"
//#define kAppSecret          @"0b171f0df710a100dbdb5d4568c6dfaf"
//#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"

#define kAppKey             @"2811802743"
#define kAppSecret          @"0f739f990cdd10a04a157e2a5dca8ed2"
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"

//------------------------------------url-------------------------------------
#define URL_HOME_TIMELINE  @"statuses/home_timeline.json" //最新微博列表
#define URL_COMMENTS_SHOW  @"comments/show.json"          //评论列表
#define URL_UPDATE         @"statuses/update.json"        //发微博（不带图）
#define URL_UPLOAD         @"statuses/upload.json"        //发微博（上传图片）
#define URL_POIS           @"place/nearby/pois.json"      //附近的位置


#define URL_MENTIONS       @"statuses/mentions.json"      //获取@到我的评论


#define URL_USER_SHOW      @"users/show.json"             //用户资料
#define URL_USER_TIMELINE  @"statuses/user_timeline.json" //用户的微博列表
#define URL_FOLLOWERS      @"friendships/followers.json"  //粉丝列表
#define URL_FRIENDS        @"friendships/friends.json"    //关注列表







//颜色
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//font color keys
#define kNavigationBarTitleLabel @"kNavigationBarTitleLabel"
#define kThemeListLabel          @"kThemeListLabel"


//NSUserDefaults 保存主题
#define kThemeName @"kThemeName"
//主题 通知
#define kThemeDidChangeNotification @"kThemeDidChangeNofication"


//图片浏览模式
#define kBrowMode @"kBrowMode"
#define LargeBrowMode 1 //大图浏览模式
#define SmallBrowMode 2 //小图浏览模式
//图片浏览模式 通知
#define kReloadWeiboTableNofication @"kReloadWeiboTableNofication"






