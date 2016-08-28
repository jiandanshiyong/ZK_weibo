//
//  UIFactory.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/7.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory


+ (ThemeButton *)createButton:(NSString *)imageName highlighted:(NSString *)highlightedName{
    ThemeButton *button = [[ThemeButton alloc] initWithImage:imageName highlighted:highlightedName];
    return [button autorelease];
}

+ (ThemeButton *)createButtonWithBackgound:(NSString *)backgroundImageName
                     backgroundHighlighted:(NSString *)highlightedName{
    ThemeButton *button = [[ThemeButton alloc] initWithBackground:backgroundImageName highlightedBackground:highlightedName];
    return [button autorelease];
}

//创建导航栏上的按钮
+ (UIButton *)createNavigationButton:(CGRect)frame
                               title:(NSString *)title
                              target:(id)target
                              action:(SEL)action{
   ThemeButton *button =[self createButtonWithBackgound:@"navigationbar_button_background.png"
              backgroundHighlighted:@"navigationbar_button_delete_background.png"];
    button.frame =frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    button.leftCapWidth =3; //从5开始拉伸
    
    return button;
}


+ (ThemeImageView *)createImageView:(NSString *)imageName{
    ThemeImageView *themeImage = [[ThemeImageView alloc] initWithImageName:imageName];
    return [themeImage autorelease];
}

+ (ThemeLabel *)createLabel:(NSString *)colorName{
    ThemeLabel *themeLabel = [[ThemeLabel alloc] initWithColorName:colorName];
    return themeLabel;
}

@end
