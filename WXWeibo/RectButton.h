//
//  RectButton.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/11.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RectButton : UIButton{
    UILabel *_rectTitleLabel;
    UILabel *_subtitleLabel;
    
}

@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *subtitle;

@end
