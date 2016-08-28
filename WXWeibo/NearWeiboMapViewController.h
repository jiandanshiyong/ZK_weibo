//
//  NearWeiboMapViewController.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/21.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NearWeiboMapViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property(nonatomic, retain)NSArray *data;

@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@end
