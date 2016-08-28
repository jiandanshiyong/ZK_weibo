//
//  WXFaceView.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/16.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
// 表情视图

#import "WXFaceView.h"

#define item_width 42
#define item_heigh 45

@implementation WXFaceView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.pageNum =items.count;
        self.backgroundColor =[UIColor clearColor];
    }
    return self;
}

/**
 * 行 row:4  
 * 列 column:7
 * 表情尺寸： 30*30 pixels
 */
- (void)initData{
    items =[[NSMutableArray alloc] init];
    
    //-----------整理表情，为一个二维数组-----------
    NSString *filePath =[[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *fileArray =[NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *item2D =nil;
    for (int i=0; i<fileArray.count; i++) {
        NSDictionary *item =fileArray[i];
        //每隔28次，创建二维小数组
        if (i % 28 ==0) {
            item2D =[NSMutableArray arrayWithCapacity:28];
            [items addObject:item2D];
        }
        [item2D addObject:item];
    }
    
    //设置尺寸
    self.width =items.count*320;
    self.height = 4*item_heigh;
    
    //放大镜
    magnifierView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)];
    magnifierView.image =[UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
    magnifierView.hidden =YES;
    magnifierView.backgroundColor =[UIColor clearColor];
    [self addSubview:magnifierView];
    
    UIImageView *faceItem =[[UIImageView alloc]initWithFrame:CGRectMake((64-30)/2, 15, 30, 30)];
    faceItem.tag =2016;
    faceItem.backgroundColor =[UIColor clearColor];
    [magnifierView addSubview:faceItem];
}

/*
 *items =[
             ["表情1","表情2","表情3",......"表情28"],
             ["表情1","表情2","表情3",......"表情28"],
             ["表情1","表情2","表情3",......"表情28"],
        ];
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //定义列、行
    int row =0, colum =0;
    
    for (int i =0; i<items.count; i++) {
        NSArray *item2D =items[i];
        
        for (int j =0; j<item2D.count; j++) {
            NSDictionary *item =item2D[j];
            NSString *imageName =[item  objectForKey:@"png"];
            UIImage *image =[UIImage imageNamed:imageName];
            
            CGRect frame = CGRectMake(colum*item_width+15, row*item_heigh+15, 30, 30);
            //考虑页数，需要加上前几页的宽度
            float x =(i*320) +frame.origin.x;
            frame.origin.x =x;
            
            [image drawInRect:frame];
            
            
            //更新列和行
            colum++;
            if (colum %7 ==0) {
                row++;
                colum =0;
            }
            if (row == 4) {
                row =0;
            }
            
        }
    }
}


- (void)touchFace:(CGPoint)point{
    //页数
    int page =point.x /320;
    
    float x =point.x -page*320-10;
    float y =point.y-15;
    
    //计算列和行
    int colum =x/item_width;
    int row =y/item_heigh;
    
    if (colum > 6) {
        colum =6;
    }
    if (colum < 0) {
        colum =0;
    }
    if (row > 3) {
        row =3;
    }
    if (row < 0) {
        row =0;
    }
    
    //计算选种表情的索引
    int index =colum +row*7;
    
    NSArray *items2D =items[page];
    NSDictionary *item =items2D[index];
    NSString *faceName =[item objectForKey:@"chs"];
    
    if (![self.selectFaceName isEqualToString:faceName] || self.selectFaceName==nil ) {
        NSString *imageName =[item objectForKey:@"png"];
        UIImage *image =[UIImage imageNamed:imageName];
        
        UIImageView *faceItem =(UIImageView *)[magnifierView viewWithTag:2016];
        faceItem.image =image;
        self.selectFaceName =faceName;
        
        magnifierView.left =(page*320)+colum*item_width;
        magnifierView.bottom =row*item_heigh+30;
    }
}


//touch事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    magnifierView.hidden =NO;
    
    UITouch *touch =[touches anyObject];
    CGPoint point =[touch locationInView:self];
    [self touchFace:point];
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView =(UIScrollView *)self.superview;
        scrollView.scrollEnabled =NO;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject];
    CGPoint point =[touch locationInView:self];
    [self touchFace:point];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    magnifierView.hidden =YES;
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView =(UIScrollView *)self.superview;
        scrollView.scrollEnabled =YES;
    }
    
    if (self.block != nil) {
        _block(_selectFaceName);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    magnifierView.hidden =YES;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView =(UIScrollView *)self.superview;
        scrollView.scrollEnabled =YES;
    }
}

@end
