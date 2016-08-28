//
//  ThemeManager.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/6.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
// 主题管理类

#import "ThemeManager.h"

static ThemeManager *sigleton =nil;

@implementation ThemeManager

+ (ThemeManager *)shareInstance{
    if (sigleton == nil) {
        @synchronized(self) {
            sigleton =[[ThemeManager alloc]init];
        }
    }
    return sigleton;
}

- (id)init{
    self =[super init];
    if (self) {
        //读取主题配置文件
        NSString *themePath =[[NSBundle mainBundle]pathForResource:@"theme" ofType:@"plist"];
        self.themePlist =[NSDictionary dictionaryWithContentsOfFile:themePath];
        
        //默认
        self.themeName =nil;
    }
    return self;
}

//切换主题时，会调用此方法设置主题名称
- (void)setThemeName:(NSString *)themeName {
    if (_themeName != themeName) {
        [_themeName release];
        _themeName = [themeName copy];
    }
    
    //切换主题，重新加载当前主题下的字体配置文件
    NSString *themeDir = [self getThemePath];
    NSString *filePath = [themeDir stringByAppendingPathComponent:@"fontColor.plist"];
    self.fontColorPlist = [NSDictionary dictionaryWithContentsOfFile:filePath];
}

//获取主题路径
-(NSString *)getThemePath{
    if(self.themeName ==nil){
        //如果主题名为空，则使用项目包根目录下的默认主题
        NSString *resourcePath =[[NSBundle mainBundle] resourcePath];
        return resourcePath;
    }
    
    //从配置文件取出主题目录 如：Skins/blue
    NSString *themePath =[self.themePlist objectForKey:_themeName];
    
    //程序包主路径
    NSString *resourcePath =[[NSBundle mainBundle] resourcePath];
    //完成路径
    NSString *path = [resourcePath stringByAppendingPathComponent:themePath];
    
    return path;
}


//返回当前主题下图片
- (UIImage *)getThemeImage:(NSString *)imageName{
    if(imageName.length ==0){
        return nil;
    }
    //获取主题目录
    NSString *themePath =[self getThemePath];
    //imageName在当前主题的路径
    NSString *imagePath =[themePath stringByAppendingPathComponent:imageName];
    
    UIImage *image =[UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}


- (UIColor *)getColorWithName:(NSString *)name{
    if (name.length ==0) {
        return nil;
    }
    
    //返回三色值 如：255，255，255
    NSString *rgb =[_fontColorPlist objectForKey:name];
    NSArray *rgbs =[ rgb componentsSeparatedByString:@","];
    if (rgbs.count ==3) {
        float r =[rgbs[0] floatValue];
        float g =[rgbs[1] floatValue];
        float b =[rgbs[2] floatValue];
        UIColor *color =Color(r, g, b, 1);
        return color;
    }
    return nil;
}



//限制当前对象创建多实例
#pragma mark - sengleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sigleton == nil) {
            sigleton = [super allocWithZone:zone];
        }
    }
    return sigleton;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

- (oneway void)release {
}

- (id)autorelease {
    return self;
}


@end
