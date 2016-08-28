//
//  WXImageView.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef void(^ImageBlock)(void);

@interface WXImageView : UIImageView

@property(nonatomic,copy)ImageBlock touchBlock;

@end
