//
//  WeiboAnnotation.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/21.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import "WeiboAnnotation.h"
#import <MapKit/MapKit.h>

@implementation WeiboAnnotation

- (id)initWithWeibo:(WeiboModel *)weibo{
    self =[super init];
    if (self != nil) {
        self.weiboModel =weibo;
    }
    return self;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel{
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel =[weiboModel retain];
    }
    
    //"null" --> NSNull
    NSDictionary *geo =weiboModel.geo;
    if ([geo isKindOfClass:[NSDictionary class]]) {
        NSArray *coord =[geo objectForKey:@"coordinates"];
        if (coord.count ==2) {
            float lat =[[coord objectAtIndex:0] floatValue];
            float lon =[[coord objectAtIndex:1] floatValue];
            
            self.coordinate =CLLocationCoordinate2DMake(lat, lon);
        }
    }
}

@end
