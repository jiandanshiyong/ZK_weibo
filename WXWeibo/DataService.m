//
//  DataService.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/20.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
// 使用ASIHTTPRequest封装网络请求

#import "DataService.h"
#import "JSONKit.h"

#define BASE_URL @"https://open.weibo.cn/2/"

@implementation DataService

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlString
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                     completeBlock:(RequestFinishBlock)block{
    
    //取得认证信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo =[defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *accessToken =[sinaweiboInfo objectForKey:@"AccessTokenKey"];
    
    //拼接URL
    //https://open.weibo.cn/2/remind/unread_count.json?access_token=2.00EG_p_GJ2CSEDe017b90194WSMMlB
    urlString =[BASE_URL stringByAppendingFormat:@"%@?access_token=%@",urlString,accessToken];
    
    //处理GET请求方式
    NSComparisonResult *comparRet1 =[httpMethod caseInsensitiveCompare:@"GET"];
    if (comparRet1 == NSOrderedSame) {
        NSMutableString *paramString =[NSMutableString string];
        NSArray *allkeys =[params allKeys];
        for (int i =0; i<allkeys.count; i++) {
            NSString *key = allkeys[i];
            id value =params[key];
            
            [paramString appendFormat:@"%@=%@",key,value];
            
            if (i<params.count-1) {
                [paramString appendString:@"&"];
            }
        }
        
        if (paramString.length >0) {
           urlString =[urlString stringByAppendingFormat:@"&%@",paramString ];
        }
    }
    NSLog(@"GET url:%@",urlString);
    
    NSURL *url =[NSURL URLWithString:urlString];
    __block ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:60]; //设置请求超时时间
    [request setRequestMethod:httpMethod];
    
    //处理POST请求方式
    NSComparisonResult *comparRet2 =[httpMethod caseInsensitiveCompare:@"POST"];
    if (comparRet2 == NSOrderedSame) {
        NSArray *allkeys =[params allKeys];
        for (int i =0; i<params.count; i++) {
            NSString *key = allkeys[i];
            id value =params[key];
            
            //判断是否是文件上传
            if ([value isKindOfClass:[NSData class]]) {
                [request addData:value forKey:key];
            } else{
                [request addPostValue:value forKey:key];
            }
        }
    }
    
    //设置请求完成的Block 注意避免request的循环引用
    [request setCompletionBlock:^{
        NSData *data =request.responseData;
        float version =[[[UIDevice currentDevice] systemVersion] floatValue];
        id result =nil;
        if (version >=5.0) {
            result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        } else{
            result =[data objectFromJSONData];
        }
        
        if (block != nil) {
            block(result);
        }
        
    }];
    
    [request startAsynchronous];
    
    return nil;
}

@end
