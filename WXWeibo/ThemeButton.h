//
//  ThemeButton.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/7.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

//Normal状态下的图片名称
@property(nonatomic,copy)NSString *imageName;
//高亮状态下的图片名称
@property(nonatomic,copy)NSString *highligtImageName;

//Normal状态下的背景图片名称
@property(nonatomic,copy)NSString *backgroundImageName;
//高亮状态下的背景图片名称
@property(nonatomic,copy)NSString *backgroundHighligtImageName;

//设置图片拉伸的位置
@property(nonatomic,assign)int leftCapWidth;
@property(nonatomic,assign)int topCapHeight;

- (id)initWithImage:(NSString *)imageName highlighted:(NSString *)highligtImageName;

- (id)initWithBackground:(NSString *)backgroundImageName
   highlightedBackground:(NSString *)backgroundHighligtImageName;

@end
