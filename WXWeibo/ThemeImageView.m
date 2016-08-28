//
//  ThemeImageView.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/7.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

- (id)initWithImageName:(NSString *)imageName{
    self =[self init];
    if (self != nil) {
        self.imageName =imageName;
    }
    return self;
}


- (id)init{
    self = [super init];
    if (self) {
        //监听主题切换通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
}


- (void)setImageName:(NSString *)imageName{
    if (_imageName != imageName) {
        [_imageName release];
        _imageName =[imageName copy];
    }
    
    [self loadThemeImage];
}


#pragma mark - NSNotification actions
//主题切换的通知
- (void)themeNotification:(NSNotification *)notificaiton{
    [self loadThemeImage];
}

//加载当前主题下对应的图片
- (void)loadThemeImage{
    if (self.imageName ==nil) {
        return;
    }
    
    UIImage *image =[[ThemeManager shareInstance]getThemeImage:_imageName];
    //切换主题时 重新拉伸
    image =[image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    self.image =image;
}


@end
