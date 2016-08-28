//
//  UIUtils.m
//  WXTime
//
//  Created by wei.chen on 12-7-22.
//  Copyright (c) 2012年 www.iphonetrain.com 无限互联ios开发培训中心 All rights reserved.
//

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"

@implementation UIUtils

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    //两种获取document路径的方式
//    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	[formatter release];
	return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    
    //将与国家和语言相关的信息进行简单的组合，包括货币、语言、国家等的信息。
    formatter.locale =[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E M d HH:mm:ss Z yyyy";
    NSDate *createDate = [UIUtils dateFromFomate:datestring formate:formate];
    NSString *text = [UIUtils stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

+ (NSString *)parseLink:(NSString *)text{
    //表达式
    //\w配的是：匹配字母或数字或下划线或汉字
    //        NSString *regex = @"@\\w+";   //匹配 "@用户"
    //        NSString *regex = @"#\\w+#";  //匹配 "#话题#"
    //        NSString *regex = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";   //匹配 “http://...”
    //三种表达式集成一起
    NSString *regex = @"(@\\w+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";
    NSArray *array = [text componentsMatchedByRegex:regex];
    
    NSString *taget =nil ;
    for (NSString *linkString in array) {
        if ([linkString hasPrefix:@"@"]) {
            taget = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>",[linkString URLEncodedString],linkString];
        }
        else if ([linkString hasPrefix:@"#"]) {
            taget = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",[linkString URLEncodedString],linkString];
        }
        else if ([linkString hasPrefix:@"http"]) {
            taget = [NSString stringWithFormat:@"<a href='%@'>%@</a>",linkString,linkString];
        }
        
        if (taget != nil) {
            text = [text stringByReplacingOccurrencesOfString:linkString withString:taget];
        }
    }
    
    return text;
}

@end
