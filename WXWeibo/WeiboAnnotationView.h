//
//  WeiboAnnotationView.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/21.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WeiboAnnotationView : MKAnnotationView{
    UIImageView *userImage;     //用户头像
    UIImageView *weiboImage;    //微博图片视图
    UILabel *textLabel;         //微博内容

}

@end
