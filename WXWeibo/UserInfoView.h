//
//  UserInfoView.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/11.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;
@class RectButton;
@interface UserInfoView : UIView

@property(nonatomic, retain)UserModel *user;

@property (retain, nonatomic) IBOutlet UIImageView *userImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;
@property (retain, nonatomic) IBOutlet UILabel *countLabel;
@property (retain, nonatomic) IBOutlet RectButton *attButton;
@property (retain, nonatomic) IBOutlet RectButton *fansButton;

- (IBAction)attAction:(id)sender;
- (IBAction)fansAction:(id)sender;

@end
