//
//  DiscoverViewController.h
//  WXWeibo
//  广场控制器

//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseViewController.h"

@interface DiscoverViewController : BaseViewController

@property (retain, nonatomic) IBOutlet UIButton *nearWeiboButton;
@property (retain, nonatomic) IBOutlet UIButton *nearUserButton;

- (IBAction)nearWeiboAction:(id)sender;
- (IBAction)nearUserAction:(id)sender;

@end
