//
//  NearWeiboMapViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/21.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import "NearWeiboMapViewController.h"
#import "DataService.h"
#import "WeiboModel.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"

@interface NearWeiboMapViewController ()

@end

@implementation NearWeiboMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //请求定位服务
    CLLocationManager *locationManager=[[CLLocationManager alloc]init];
    
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [locationManager requestWhenInUseAuthorization];
    }
    
    //设置代理
    locationManager.delegate=self;
    //设置定位精度
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //启动跟踪定位
    [locationManager startUpdatingLocation];
    
}

#pragma mark - Data
- (void)loadNearWeiboData:(NSString *)lon latitude:(NSString *)lat{
    
    NSMutableDictionary *params =[NSMutableDictionary dictionaryWithObjectsAndKeys:lon,@"long",lat,@"lat", nil];
    
    [DataService requestWithURL:@"place/nearby_timeline.json" params:params httpMethod:@"GET" completeBlock:^(id result) {
        [self loadDataFinish:result];
    }];
}

- (void)loadDataFinish:(NSDictionary *)result{
    NSArray *status =[result objectForKey:@"statuses"];
    NSMutableArray *weibos =[NSMutableArray arrayWithCapacity:status.count];
    for (int i=0; i<status.count; i++) {
        NSDictionary *statusDic = status[i];
        WeiboModel *weibo =[[WeiboModel alloc] initWithDataDic:statusDic];
        [weibos addObject:weibo];
        [weibo release];
        
        //创建Annotation对象，添加到地图上
        WeiboAnnotation *weiboAnnotation = [[WeiboAnnotation alloc] initWithWeibo:weibo];
//        [self.mapView addAnnotation:weiboAnnotation];
        
        //地图加载weibo视图,逐条显示效果(利用延迟时间变大进行控制)
        [self.mapView performSelector:@selector(addAnnotation:) withObject:weiboAnnotation afterDelay:i*0.05];
    }
}

#pragma mark - CLLocationManager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    //如果不需要实时定位，使用完及时关闭定位服务
    [manager stopUpdatingLocation];
    
    CLLocationCoordinate2D coordinate = newLocation.coordinate;//位置坐标
    
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
    MKCoordinateSpan span=MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region=MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
    
    
    if (self.data ==nil) {
        NSString *longitude =[NSString stringWithFormat:@"%f",coordinate.longitude];
        NSString *latitude =[NSString stringWithFormat:@"%f", coordinate.latitude];
        
        [self loadNearWeiboData:longitude latitude:latitude];
    }
}


#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *key1=@"AnnotationKey1";
    WeiboAnnotationView *annotationView=(WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:key1];
    //如果缓存池中不存在则新建
    if (!annotationView) {
        annotationView=[[WeiboAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
    }
    
    return annotationView;
    
}

//每个加载一个weibo视图 调用一次
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    
    //0.7 --- 1.2
    //1.2 --- 0.7
    for (UIView *annotationView in views) {
        CGAffineTransform transform = annotationView.transform;
        annotationView.transform = CGAffineTransformScale(transform, 0.7, 0.7);
        annotationView.alpha =0;
        
        [UIView animateWithDuration:0.5 animations:^{
            //动画1
            annotationView.transform = CGAffineTransformScale(transform, 1.2, 1.2);
            annotationView.alpha =1;
        } completion:^(BOOL finished) {
            //动画2
            [UIView animateWithDuration:0.5 animations:^{
                annotationView.transform =CGAffineTransformIdentity;
            }];
        }];
    }
}

#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mapView release];
    [super dealloc];
}

@end
