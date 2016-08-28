//
//  RightViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "RightViewController.h"
#import "SendViewController.h"
#import "BaseNavigationController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
}


- (IBAction)sendAction:(UIButton *)sender {
    if (sender.tag ==100) {
        SendViewController *sendCtrl =[[SendViewController alloc]init];
        BaseNavigationController *sendNav =[[BaseNavigationController alloc]initWithRootViewController:sendCtrl];
        
        [self.appDelegate.menuCtrl presentViewController:sendNav animated:YES completion:nil];
//        [self presentViewController:sendNav animated:YES completion:nil];
        
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
