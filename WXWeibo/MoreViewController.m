//
//  MoreViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeViewController.h"
#import "BrowModeViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"更多";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row ==0) {
        cell.textLabel.text =@"主题";
    }
    if (indexPath.row ==1) {
        cell.textLabel.text =@"更多图片浏览模式";
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        ThemeViewController *themeViewCtroller =[[ThemeViewController alloc]init];
        [self.navigationController pushViewController:themeViewCtroller animated:YES];
        [themeViewCtroller release];
    }
    if (indexPath.row ==1) {
        BrowModeViewController *browModelVC =[[BrowModeViewController alloc]init];
        [self.navigationController pushViewController:browModelVC animated:YES];
        [browModelVC release];
    }
}


@end
