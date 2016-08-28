//
//  UIView+Additions.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/11.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
// 扩展UIView 使用事件响应者链拿到UIViewController

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (UIViewController *)viewController{

    UIResponder *next =[self nextResponder];
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = [next nextResponder];
        
    } while (next !=nil);
    
    return nil;
}

@end
