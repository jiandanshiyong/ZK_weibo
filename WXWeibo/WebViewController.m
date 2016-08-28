//
//  WebViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithUrl:(NSString *)url{
    self =[super init];
    if (self != nil) {
        _url =[url copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url =[NSURL URLWithString:_url];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    self.title =@"载入中...";
    [UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
}



- (IBAction)goBack:(id)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

- (IBAction)goForward:(id)sender {
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

- (IBAction)reload:(id)sender {
    [_webView reload];
}

#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    
    NSString *title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title =title;
}

#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}

@end
