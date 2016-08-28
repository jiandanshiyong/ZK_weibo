//
//  ThemeManager.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/6.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject

//当前主题名称
@property(nonatomic,retain)NSString *themeName;
//配置主题的Plist文件
@property(nonatomic,retain)NSDictionary *themePlist;

+ (ThemeManager *)shareInstance;

//返回当前主题下图片
- (UIImage *)getThemeImage:(NSString *)imageName;


//Label字体颜色配置plist文件
@property(nonatomic, retain)NSDictionary *fontColorPlist;

//返回当前路径下字体颜色
- (UIColor *)getColorWithName:(NSString *)name;


@end
