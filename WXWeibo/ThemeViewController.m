//
//  ThemeViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/7.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"
#import "UIFactory.h"

@interface ThemeViewController (){
    NSArray *themes;
}

@end

@implementation ThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取得所有的主题名
    themes =[[ThemeManager shareInstance].themePlist allKeys];
    [themes retain];
    
    self.title =@"主题切换";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify =@"themeCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        UILabel *textLabel =[UIFactory createLabel:kThemeListLabel];
        textLabel.frame=CGRectMake(10, 10, 200, 30);
        textLabel.backgroundColor =[UIColor clearColor];
        textLabel.font =[UIFont boldSystemFontOfSize:18.0f];
        textLabel.tag =2016;
        [cell.contentView addSubview:textLabel];
    }
    UILabel *textlabel =(UILabel *)[cell.contentView viewWithTag:2016];
    //当前cell的主题名
    NSString *name =themes[indexPath.row];
    textlabel.text =name;
    
    //当前使用的主题名称
    NSString *themeName =[ThemeManager shareInstance].themeName;
    if (themeName ==nil) {
        themeName=@"默认";
    }
    
    //比较cell中的主题名和当前使用的主题名是否相同
    if ([themeName isEqualToString:name]) {
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType =UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelete
//切换主题
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *themeName =themes[indexPath.row];
    if ([themeName isEqualToString:@"默认"]) {
        themeName =nil;
    }

    //保存主题到本地
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:kThemeName];
    [[NSUserDefaults standardUserDefaults] synchronize] ;
    
    //传参，并通知
    [ThemeManager shareInstance].themeName =themeName;
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:themeName];
    
    //刷新列表
    [tableView reloadData];
}



@end
