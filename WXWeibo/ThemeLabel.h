//
//  ThemeLabel.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/7.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeLabel : UILabel

@property(nonatomic, copy)NSString *colorName;

- (id)initWithColorName:(NSString *)colorName;

@end
