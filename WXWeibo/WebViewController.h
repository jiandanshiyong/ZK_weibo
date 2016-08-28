//
//  WebViewController.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate>{

    NSString *_url;
}

- (id)initWithUrl:(NSString *)url;

@property (retain, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)reload:(id)sender;

@end
