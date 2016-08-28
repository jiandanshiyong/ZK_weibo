//
//  WXImageView.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//
// 图片超链接 点击手势block

#import "WXImageView.h"

@implementation WXImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled =YES;
        
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.touchBlock) {
        _touchBlock();
    }

}

@end
