//
//  UserGridView.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/20.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import "UserGridView.h"
#import "UserModel.h"
#import "UIButton+WebCache.h"
#import "UserViewController.h"

@implementation UserGridView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       UIView *gridView =[[[NSBundle mainBundle] loadNibNamed:@"UserGridView" owner:self options:nil] lastObject];
        gridView.backgroundColor =[UIColor clearColor];
        self.size = gridView.size;
        [self addSubview:gridView];
        
        //添加背景
        UIImage *image =[UIImage imageNamed:@"profile_button3_1.png"];
        UIImageView *backgroundView =[[UIImageView alloc] initWithImage:image];
        backgroundView.frame =self.bounds;
        [self insertSubview:backgroundView atIndex:0];
    }
    return self;
}

- (void)dealloc {
    [_nickLabel release];
    [_fansLabel release];
    [_imageButton release];
    [super dealloc];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    //昵称
    self.nickLabel.text = self.userModel.screen_name;
    
    //粉丝数
    long  fansL =[self.userModel.followers_count longValue];
    NSString *fans = [NSString stringWithFormat:@"%ld",fansL];
    if (fansL >=10000) {
        fansL =fansL/10000;
        fans =[NSString stringWithFormat:@"%ld万",fansL];
    }
    self.fansLabel.text =fans;
    
    //用户头像url
    NSString *urlString =self.userModel.profile_image_url;
    [self.imageButton setImageWithURL:[NSURL URLWithString:urlString]];
    
}

- (IBAction)userImageAction:(id)sender {
    UserViewController *userCtrl =[[UserViewController alloc] init];
    userCtrl.userName =self.userModel.screen_name;
    
    [self.viewController.navigationController pushViewController:userCtrl animated:YES];
}


@end
