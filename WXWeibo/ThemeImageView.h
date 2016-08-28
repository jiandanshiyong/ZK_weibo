//
//  ThemeImageView.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/7.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

//图片名称
@property(nonatomic, copy)NSString *imageName;

@property(nonatomic,assign)int leftCapWidth;
@property(nonatomic,assign)int topCapHeight;

-(id)initWithImageName:(NSString *)imageName;


@end
