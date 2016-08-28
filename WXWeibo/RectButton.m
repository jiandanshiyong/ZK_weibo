//
//  RectButton.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/11.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "RectButton.h"

@implementation RectButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    if (_title !=title) {
        [_title release];
        _title =[title copy];
    }
    
    [self setTitle:nil forState:UIControlStateNormal];
    
    if (_rectTitleLabel ==nil) {
        _rectTitleLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        _rectTitleLabel.backgroundColor =[UIColor clearColor];
        _rectTitleLabel.font =[UIFont systemFontOfSize:18.0f];
        _rectTitleLabel.textColor =[UIColor blackColor];
        _rectTitleLabel.textAlignment =NSTextAlignmentCenter;
        [self addSubview:_rectTitleLabel];
    }
}

- (void)setSubtitle:(NSString *)subtitle{
    if (_subtitle !=subtitle) {
        [_subtitle release];
        _subtitle =[subtitle copy];
    }
    
    [self setTitle:nil forState:UIControlStateNormal];
    
    if (_subtitleLabel ==nil) {
        _subtitleLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.backgroundColor =[UIColor clearColor];
        _subtitleLabel.font =[UIFont systemFontOfSize:18.0f];
        _subtitleLabel.textColor =[UIColor blackColor];
        _subtitleLabel.textAlignment =NSTextAlignmentCenter;
        [self addSubview:_subtitleLabel];
    }
}

//layoutSubviews 展示数据、子视图布局
- (void)layoutSubviews{
    
    _subtitleLabel.text =_subtitle;
    _subtitleLabel.frame =CGRectMake(10, 15, 50, 20);

    _rectTitleLabel.text =_title;
    _rectTitleLabel.frame =CGRectMake(10, 35, 50, 20);
    
}

- (void)drawRect:(CGRect)rect{
    
    [[UIImage imageNamed:@"userinfo_apps_background"] drawInRect:rect ];
}

@end
