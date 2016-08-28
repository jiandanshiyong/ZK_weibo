//
//  WeiboAnnotationView.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/21.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "UIImageView+WebCache.h"

@implementation WeiboAnnotationView

- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self initView];
    }
    return self;
}

- (void)initView{
    userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    userImage.layer.borderColor =[UIColor whiteColor].CGColor;
    userImage.layer.borderWidth = 1;
    
    weiboImage =[[UIImageView alloc] initWithFrame:CGRectZero];
    weiboImage.backgroundColor = [UIColor blackColor];
//    weiboImage.contentMode = UIViewContentModeScaleAspectFit;
    
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.font =[UIFont systemFontOfSize:12.0];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines =3;
    
    [self addSubview:weiboImage];
    [self addSubview:textLabel];
    [self addSubview:userImage];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    WeiboAnnotation *weiboAnnotation =self.annotation;
    WeiboModel * weibo = nil;
    if ([weiboAnnotation isKindOfClass:[weiboAnnotation class]]) {
       weibo = weiboAnnotation.weiboModel;
    }
    
    NSString *thumbnailImage = weibo.thumbnailImage;
    if (thumbnailImage.length >0) {  //带微博图片
        self.image = [UIImage imageNamed:@"nearby_map_photo_bg.png"];
        
        //加载微博图片
        weiboImage.frame =CGRectMake(15, 15, 90, 85);
        [weiboImage setImageWithURL:[NSURL URLWithString:thumbnailImage]];
        
        //加载用户头像
        userImage.frame =CGRectMake(70, 70, 30, 30);
        NSString *userURL =weibo.user.profile_image_url;
        [userImage setImageWithURL:[NSURL URLWithString:userURL]];
        
        weiboImage.hidden =NO;
        textLabel.hidden =YES;
    }
    
    //不带微博图片
    else {
        self.image = [UIImage imageNamed:@"nearby_map_content.png"];
        
        //加载用户头像
        userImage.frame =CGRectMake(20, 20, 45, 45);
        NSString *userURL =weibo.user.profile_image_url;
        [userImage setImageWithURL:[NSURL URLWithString:userURL]];
        
        //微博的内容
        textLabel.frame =CGRectMake(userImage.right+5, userImage.top, 110, 45);
        textLabel.text =weibo.text;
        
        textLabel.hidden =NO;
        weiboImage.hidden =YES;
    }
    
}

@end
