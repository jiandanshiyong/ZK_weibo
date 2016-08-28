//
//  DiscoverViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearWeiboMapViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"广场";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    for (int i =100; i<=101; i++) {
        UIButton *button =(UIButton *)[self.view viewWithTag:i];
        button.layer.shadowColor =[UIColor blackColor].CGColor;
        button.layer.shadowOffset =CGSizeMake(2, 2); //偏移量
        button.layer.shadowOpacity =1; //阴影透明度
//        button.layer.shadowRadius = 13; //半径
    }
   
    
}


- (IBAction)nearWeiboAction:(id)sender {
    NearWeiboMapViewController *near = [[NearWeiboMapViewController alloc] init];
    [self.navigationController pushViewController:near animated:YES];
}

- (IBAction)nearUserAction:(id)sender {
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_nearWeiboButton release];
    [_nearUserButton release];
    [super dealloc];
}

@end
