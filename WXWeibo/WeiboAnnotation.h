//
//  WeiboAnnotation.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/21.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"

@interface WeiboAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *subtitle;

@property(nonatomic ,retain)WeiboModel *weiboModel;

- (id)initWithWeibo:(WeiboModel *)weibo;

@end
