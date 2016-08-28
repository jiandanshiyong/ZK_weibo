//
//  UIFactory.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/7.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"

@interface UIFactory : NSObject

//创建button
+ (ThemeButton *)createButton:(NSString *)imageName highlighted:(NSString *)highlightedName;
+ (ThemeButton *)createButtonWithBackgound:(NSString *)backgroundImageName
                     backgroundHighlighted:(NSString *)highlightedName;

//创建导航栏上的按钮
+ (UIButton *)createNavigationButton:(CGRect)frame
                               title:(NSString *)title
                              target:(id)target
                              action:(SEL)action;

//创建ImageView
+ (ThemeImageView *)createImageView:(NSString *)ImageName;

//创建Label
+ (ThemeLabel *)createLabel:(NSString *)colorName;
@end
