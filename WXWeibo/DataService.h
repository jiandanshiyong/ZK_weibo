//
//  DataService.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/20.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^RequestFinishBlock)(id result);

@interface DataService : NSObject

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlString
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                     completeBlock:(RequestFinishBlock)block;

@end
