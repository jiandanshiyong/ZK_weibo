//
//  UserInfoView.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/11.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "UserInfoView.h"
#import "UserModel.h"
#import "RectButton.h"
#import "UIImageView+WebCache.h"
#import "FriendshipViewController.h"

@implementation UserInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        UIView *view =[[[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:self options:nil] lastObject];
        view.backgroundColor =Color(245, 245, 245, 1);
        [self addSubview:view];
        
        self.size =view.size;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //头像
    NSString *userImageStr =self.user.avatar_large;
    [self.userImage setImageWithURL: [NSURL URLWithString:userImageStr]];
    _userImage.layer.cornerRadius =5; //圆角半径
    _userImage.layer.borderWidth =.5;//边框宽度
    _userImage.layer.borderColor =[UIColor grayColor].CGColor;//边框颜色
    _userImage.layer.masksToBounds =YES; //剪切图层边界
    
    //昵称
    self.nameLabel.text =self.user.screen_name;
    
    //性别
    NSString *gender =self.user.gender;
    NSString *sexName =@"未知";
    if ([gender isEqualToString:@"f"]) {
        sexName =@"女";
    }
    else if([gender isEqualToString:@"m"]) {
        sexName =@"男";
    }
    //地址
    NSString *location =self.user.location;
    if (location ==nil) {
        location =@"";
    }
    self.addressLabel.text =[NSString stringWithFormat:@"%@ %@",sexName,location];
    
    //简介
    self.infoLabel.text =(self.user.description)?@"":self.user.user_description;
    
    //微博数 statuses_count
    NSString *countStr=[self.user.statuses_count stringValue];
    self.countLabel.text = [NSString  stringWithFormat:@"共%@条微博",countStr];
    
    //粉丝数 followers_count
    long  fansL =[self.user.followers_count longValue];
    NSString *fans = [NSString stringWithFormat:@"%ld",fansL];
    if (fansL >=10000) {
        fansL =fansL/10000;
        fans =[NSString stringWithFormat:@"%ld万",fansL];
    }
    self.fansButton.title =@"粉丝";
    self.fansButton.subtitle =fans;
    
    //关注数 friends_count
    self.attButton.title =@"关注";
    self.attButton.subtitle =[self.user.friends_count stringValue];
    
}

- (IBAction)attAction:(id)sender {
    FriendshipViewController *friendCtrl =[[FriendshipViewController alloc] init];
    friendCtrl.userId= self.user.idstr;
    friendCtrl.shipType =Attention;
    
    [self.viewController.navigationController pushViewController:friendCtrl animated:YES];
}

- (IBAction)fansAction:(id)sender {
    FriendshipViewController *friendCtrl =[[FriendshipViewController alloc] init];
    friendCtrl.userId= self.user.idstr;
    friendCtrl.shipType =Fans;
    
    [self.viewController.navigationController pushViewController:friendCtrl animated:YES];
}



- (void)dealloc {
    [_userImage release];
    [_nameLabel release];
    [_addressLabel release];
    [_infoLabel release];
    [_countLabel release];
    [_attButton release];
    [_fansButton release];
    [super dealloc];
}


@end
