//
//  NearbyViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import "NearbyViewController.h"
#import "UIImageView+WebCache.h"
#import "DataService.h"

@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton =NO;
        self.isCacelButton =YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"我在这里";
    
    self.tableView.hidden =YES;
    [super showLoading:YES];
    
    //定位管理器
    //在info.plist中配置 NSLocationWhenInUseUsageDescription
    CLLocationManager *locationManger = [[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [locationManger requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        locationManger.delegate=self;
        //设置定位精度
        locationManger.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
        //启动跟踪定位
        [locationManger startUpdatingLocation];
    }
    
}

#pragma mark - UI
- (void)refreshUI{
    self.tableView.hidden =NO;
    [super showLoading:NO];
    
    [self.tableView reloadData];
}

#pragma mark - data
- (void)loadNearbyDataFinish:(NSDictionary *)result{
     NSArray *pois =[result objectForKey:@"pois"];
    self.data =pois;
    
    [self refreshUI];
}

#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    [manager stopUpdatingLocation];
    
    if (self.data ==nil) {
        float longitude =newLocation.coordinate.longitude;
        float latitude =newLocation.coordinate.latitude;
       
        NSString *longStr =[NSString stringWithFormat:@"%f",longitude];
        NSString *latStr =[NSString stringWithFormat:@"%f", latitude];
        
        //测试使用
//        longStr =@"116.287971";
//        latStr =@"40.141499";
        
        NSMutableDictionary *params =[NSMutableDictionary dictionaryWithObjectsAndKeys:longStr,@"long",latStr,@"lat", nil];
        
//        [self.sinaweibo requestWithURL:@"place/nearby/pois.json" params:params httpMethod:@"GET" block:^(id result) {
//            [self loadNearbyDataFinish:result];
//        }];
        
        [DataService requestWithURL:URL_POIS params:params httpMethod:@"GET" completeBlock:^(id result) {
            [self loadNearbyDataFinish:result];
        }];
        
    }

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell ==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    NSDictionary *dic = [self.data objectAtIndex: indexPath.row];
    NSString *title = [dic objectForKey:@"title"];
    NSString *address = [dic objectForKey:@"address"];
    NSString *icon = [dic objectForKey:@"icon"];
    
    cell.textLabel.text =title;
    cell.detailTextLabel.text =address;
    [cell.imageView setImageWithURL:[NSURL URLWithString:icon]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectBlock !=nil) {
        NSDictionary *dic =self.data[indexPath.row];
        _selectBlock(dic);
        
        Block_release(_selectBlock);
        _selectBlock =nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

@end
