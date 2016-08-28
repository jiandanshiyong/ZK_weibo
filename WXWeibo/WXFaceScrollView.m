//
//  WXFaceScrollView.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/17.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
// 表情面板

#import "WXFaceScrollView.h"

@implementation WXFaceScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (id)initWithSelectBlock:(SelectBlock)block{
    self =[self initWithFrame:CGRectZero];
    if (self !=nil) {
        faceView.block =block;
    }
    
    return self;
}

- (void)initViews{
    faceView =[[WXFaceView alloc] initWithFrame:CGRectZero];
    
    scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, faceView.height)];
    scrollView.contentSize =CGSizeMake(faceView.width, faceView.height);
    scrollView.pagingEnabled =YES; //分页
    scrollView.showsHorizontalScrollIndicator =NO; //滚动条
    scrollView.clipsToBounds =NO; //超出裁剪
    scrollView.delegate =self;
    [scrollView addSubview:faceView];
    [self addSubview:scrollView];
    
    pageControl =[[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollView.bottom, 0, 20)];
    pageControl.backgroundColor =[UIColor clearColor];
    pageControl.numberOfPages =faceView.pageNum;
    pageControl.currentPage =0;
    [self addSubview:pageControl];
    
    self.height =scrollView.height+pageControl.height;
    self.width =scrollView.width;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView{
    int pageNumber =_scrollView.contentOffset.x/320;
    pageControl.currentPage =pageNumber;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     [[UIImage imageNamed:@"emoticon_keyboard_background.png"] drawInRect:rect];
}


@end
