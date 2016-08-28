//
//  ThemeLabel.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/7.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

- (id)initWithColorName:(NSString *)colorName{
    self =[self init];
    if (self) {
        self.colorName =colorName;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//重载
-(void)setColorName:(NSString *)colorName{
    if (_colorName !=colorName) {
        [_colorName release];
        _colorName =[colorName copy];
    }
    [self setColor];
}

#pragma mark - NSNotification actions
- (void)themeNotification:(NSNotification *)notification {
    [self setColor];
}

- (void)setColor {
    UIColor *textColor = [[ThemeManager shareInstance] getColorWithName:_colorName];
    self.textColor = textColor;
}

@end
