//
//  WeiboView.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/8.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "WeiboView.h"
#import "UIFactory.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"
#import "UIUtils.h"
#import "UserViewController.h"
#import "WebViewController.h"

#define LIST_FONT   14.0f           //列表中文本字体
#define LIST_REPOST_FONT  13.0f;    //列表中转发的文本字体
#define DETAIL_FONT  18.0f          //详情的文本字体
#define DETAIL_REPOST_FONT 17.0f    //详情中转发的文本字体


@implementation WeiboView

- (id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self _initView];
        _parseText =[NSMutableString string];
    }
    return self;
}

//初始化视图
- (void)_initView{
    //微博内容
    _textLabel =[[RTLabel alloc] initWithFrame:CGRectZero];
    _textLabel.delegate =self;
    _textLabel.font =[UIFont systemFontOfSize:14.0f];
    //十进制RGB值：r:69 g:149 b:203
    //十六进制RGB值：4595CB
    //设置链接的颜色
    _textLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    //设置链接高亮的颜色
    _textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self addSubview:_textLabel];
    
    //微博图片
    _imageView =[[UIImageView alloc]initWithFrame:CGRectZero];
    _imageView.backgroundColor =[UIColor clearColor];
    _imageView.image =[UIImage imageNamed:@"page_image_loading.png"];
    //设置图片的内容显示模式：等比例缩/放（不会被拉伸或压缩）
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    
    //转发微博视图的背景
    _repostBackgroudView =[UIFactory createImageView:@"timeline_retweet_background.png"];
    //图片拉伸： 距左25 距上10
    UIImage *image =[_repostBackgroudView.image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    _repostBackgroudView.image =image;
    _repostBackgroudView.leftCapWidth = 25;
    _repostBackgroudView.topCapHeight = 10;
    _repostBackgroudView.backgroundColor =[UIColor clearColor];
    [self insertSubview:_repostBackgroudView atIndex:0];
}

- (void)setWeiboModel:(WeiboModel *)weiboModel{
    if (_weiboModel !=weiboModel) {
        [_weiboModel release];
        _weiboModel =[weiboModel retain];
    }
    
    //创建转发的微博视图
    if (_repostView ==nil) {
        _repostView =[[WeiboView alloc]initWithFrame:CGRectZero];
        _repostView.isRepost =YES;
        _repostView.isDetail =self.isDetail;
        [self addSubview:_repostView];
    }
    
    [self parseLink];
}

//解析超链接
- (void)parseLink{
    [_parseText setString:@""];
    
    //是否为转发的微博，开头需拼接@作者
    if (_isRepost) {
        //源微博作者
        NSString *nickName =_weiboModel.user.screen_name;
        NSString *encodeName =[nickName URLEncodedString];
        [_parseText appendFormat:@"<a href='user://%@'>@%@</a>:",encodeName,nickName];
    }
    
    NSString *text = _weiboModel.text;
    
    text= [UIUtils parseLink:text];
    
    [_parseText appendString:text];
}


//layoutSubviews 展示数据、子视图布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //---------------微博内容_textLabel子视图------------------
    [self _renderLable];
    
    
    //---------------转发的微博视图_repostView------------------
    [self _renderSourceWeiboView];

    
    //---------------微博图片视图_image------------------
    [self _renderImage];
    
    
    //----------------转发的微博视图背景_repostBackgroudView---------------
    if (self.isRepost) {
        _repostBackgroudView.frame =self.bounds;
        _repostBackgroudView.hidden =NO;
    } else {
        _repostBackgroudView.hidden =YES;
    }
}

- (void)_renderLable{
    //获取字体大小
    float fontSize =[WeiboView getFontSize:self.isDetail isRepost:self.isRepost];
    _textLabel.font =[UIFont systemFontOfSize:fontSize];
    _textLabel.frame =CGRectMake(0, 0, self.width, 20);
    if (self.isRepost) {
        _textLabel.frame =CGRectMake(10, 10, self.width-20, 0);
    }
    _textLabel.text =_parseText;
    //文本内容尺寸
    CGSize textSize = _textLabel.optimumSize;
    _textLabel.height = textSize.height;

}

- (void)_renderSourceWeiboView{
    //转发的微博model
    WeiboModel *repostWeibo =_weiboModel.relWeibo;
    if (repostWeibo !=nil) {
        _repostView.hidden =NO;
        _repostView.weiboModel =repostWeibo;
        
        //计算转发微博视图的高度
        float height =[WeiboView getWeiboViewHeight:repostWeibo isRepost:YES isDetail:self.isDetail];
        _repostView.frame =CGRectMake(0, _textLabel.bottom, self.width, height);
        
    }else {
        _repostView.hidden =YES;
    }
}

- (void)_renderImage{
    if (self.isDetail) {
        //中等图
        NSString *bmiddleImage =_weiboModel.bmiddleImage;
        if (bmiddleImage !=nil && ![@""isEqualToString:bmiddleImage]) {
            _imageView.hidden =NO;
            _imageView.frame =CGRectMake(10, _textLabel.bottom+10, 280, 200);
            
            //加载网络图片数据
            [_imageView setImageWithURL:[NSURL URLWithString:bmiddleImage]];
        }else {
            _imageView.hidden =YES;
        }
        
    } else {
        //图片浏览模式
        int mode =[[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
        if (mode ==0) {
            mode =SmallBrowMode;
        }
        
        //小图浏览模式
        if (mode ==SmallBrowMode) {
            //缩略图
            NSString *thumbnailImage =_weiboModel.thumbnailImage;
            if (thumbnailImage !=nil && ![@""isEqualToString:thumbnailImage]) {
                _imageView.hidden =NO;
                _imageView.frame =CGRectMake(10, _textLabel.bottom+10, 70, 80);
                
                //加载网络图片数据
                [_imageView setImageWithURL:[NSURL URLWithString:thumbnailImage]];
            }else {
                _imageView.hidden =YES;
            }
        }
        //大图浏览模式
        else if (mode ==LargeBrowMode){
            NSString *bmiddleImage =_weiboModel.bmiddleImage;
            if (bmiddleImage !=nil && ![@""isEqualToString:bmiddleImage]) {
                _imageView.hidden =NO;
                _imageView.frame =CGRectMake(10, _textLabel.bottom+10, self.width-20, 180);
                
                //加载网络图片数据
                [_imageView setImageWithURL:[NSURL URLWithString:bmiddleImage]];
            }else {
                _imageView.hidden =YES;
            }
        }
        
    }
}

#pragma mark - 计算
//获取字体大小
+ (float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost{
    float fontSize =14.0f;
    
    if (!isDetail && !isRepost) {
        return LIST_FONT;
    }
    else if(!isDetail && isRepost){
        return LIST_REPOST_FONT
    }
    else if(isDetail && !isRepost){
        return DETAIL_FONT;
    }
    else if(isDetail && isRepost){
        return DETAIL_REPOST_FONT;
    }
    
    return fontSize;
}

//计数微博视图的高度
+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel
                     isRepost:(BOOL)isRepost
                     isDetail:(BOOL)isDetail{
    /**
     *   实现思路：计算每个子视图的高度，然后相加。
     **/
    float height = 0;
    
    //--------------------计算微博内容text的高度------------------------
    RTLabel *textLabel =[[RTLabel alloc] initWithFrame:CGRectZero];
    float fontSize =[WeiboView getFontSize:isDetail isRepost:isRepost];
    textLabel.font =[UIFont systemFontOfSize:fontSize];
    
    //判断此微博是否显示在详情页面
    if (isDetail) {
        textLabel.width = kWeibo_Width_Detail;
    } else {
        textLabel.width = kWeibo_Width_List;
    }
    
    NSString *weiboText =nil;
    if (isRepost) {
        textLabel.width -=20;
        //昵称
        NSString *nickName =weiboModel.user.screen_name;
        weiboText =[NSString stringWithFormat:@"%@:%@",nickName,weiboModel.text];
    } else {
        weiboText =weiboModel.text;
    }
    
    textLabel.text = weiboText;
    
    height += textLabel.optimumSize.height;
    

    //--------------------计算微博图片的高度------------------------
    if (isDetail) {
        NSString *bmiddleImage =weiboModel.bmiddleImage;
        if (bmiddleImage !=nil && ![@""isEqualToString:bmiddleImage]) {
            height += (200+10);
        }
    } else {
        //图片浏览模式
        int mode =[[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
        if (mode ==0) {
            mode =SmallBrowMode;
        }
        
        //小图浏览模式
        if(mode ==SmallBrowMode){
            NSString *thumbnailImage =weiboModel.thumbnailImage;
            if (thumbnailImage !=nil && ![@""isEqualToString:thumbnailImage]) {
                height += (80+10);
            }
        } else {
            NSString *bmiddleImage =weiboModel.bmiddleImage;
            if (bmiddleImage !=nil && ![@""isEqualToString:bmiddleImage]) {
                height += (180+10);
            }
        }
    }
 
    
    //--------------------计算转发微博视图的高度------------------------
    //转发的微博
    WeiboModel *relWeibo = weiboModel.relWeibo;
    if (relWeibo != nil) {
        //转发微博视图的高度
        float repostHeight = [WeiboView getWeiboViewHeight:relWeibo isRepost:YES isDetail:isDetail];
        height += (repostHeight);
    }
    
    if (isRepost == YES) {
        height +=30;
    }
    
    return height;
}

#pragma mark - RTLabel delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {

    NSString *absoluteString  =[url absoluteString];
    if ( [absoluteString hasPrefix:@"user"]) {
        NSString *urlString = [url host];
        urlString = [urlString URLDecodedString];
        if ([urlString hasPrefix:@"@"] ==1) {
             urlString = [urlString substringFromIndex:1];
        }
       
        NSLog(@"用户：%@",urlString);
        
        
        UserViewController *userCtrl =[[UserViewController alloc]init];
        userCtrl.userName = urlString;
        [self.viewController.navigationController pushViewController:userCtrl animated:YES];
        [userCtrl release];
        
    }
    else if ( [absoluteString hasPrefix:@"topic"]) {
        NSString *urlString = [url host];
        urlString = [urlString URLDecodedString];
        NSLog(@"话题：%@",urlString);
    }
    else if ( [absoluteString hasPrefix:@"http"]) {
        NSLog(@"链接：%@",url);
        
        WebViewController *webCtrl =[[WebViewController alloc]initWithUrl:absoluteString];
        [self.viewController.navigationController pushViewController:webCtrl animated:YES];
        [webCtrl release];
    }
    
}

@end
