//
//  UserGridView.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/20.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;
@interface UserGridView : UIView

@property(nonatomic ,retain)UserModel *userModel;

@property (retain, nonatomic) IBOutlet UILabel *nickLabel;
@property (retain, nonatomic) IBOutlet UILabel *fansLabel;
@property (retain, nonatomic) IBOutlet UIButton *imageButton;

- (IBAction)userImageAction:(id)sender;

@end
