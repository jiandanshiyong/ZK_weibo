//
//  WeiboCell.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/8.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "WeiboCell.h"
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "RegexKitLite.h"
#import "WXImageView.h"
#import "UserViewController.h"

@implementation WeiboCell

//纯代码cell 必须重写此方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

//初始化子视图 仅添加控件
- (void)_initView{
    //用户头像
    _userImage =[[WXImageView alloc] initWithFrame:CGRectZero];
    _userImage.backgroundColor =[UIColor clearColor];
    _userImage.layer.cornerRadius =5; //圆角半径
    _userImage.layer.borderWidth =.5;//边框宽度
    _userImage.layer.borderColor =[UIColor grayColor].CGColor;//边框颜色
    _userImage.layer.masksToBounds =YES; //剪切图层边界
    [self.contentView addSubview:_userImage];
    
    //昵称
    _nickLabel =[[UILabel alloc]initWithFrame:CGRectZero];
    _nickLabel.backgroundColor =[UIColor clearColor];
    _nickLabel.font =[UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_nickLabel];
    
    //转发数
    _repostCountLabel =[[UILabel alloc]initWithFrame:CGRectZero];
    _repostCountLabel.backgroundColor =[UIColor clearColor];
    _repostCountLabel.font =[UIFont systemFontOfSize:12.0f];
    _repostCountLabel.textColor =[UIColor blackColor];
    [self.contentView addSubview:_repostCountLabel];
    
    //回复数
    _commentLabel =[[UILabel alloc]initWithFrame:CGRectZero];
    _commentLabel.backgroundColor =[UIColor clearColor];
    _commentLabel.font =[UIFont systemFontOfSize:12.0f];
    _commentLabel.textColor =[UIColor blackColor];
    [self.contentView addSubview:_commentLabel];
    
    //微博来源
    _sourceLabel =[[UILabel alloc]initWithFrame:CGRectZero];
    _sourceLabel.backgroundColor =[UIColor clearColor];
    _sourceLabel.font =[UIFont systemFontOfSize:12.0f];
    _sourceLabel.textColor =[UIColor blackColor];
    [self.contentView addSubview:_sourceLabel];
    
    //发布时间
    _createLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createLabel.font = [UIFont systemFontOfSize:12.0];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_createLabel];
    
    //微博内容
    _weiboView =[[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];
    
    //设置cell的选中背景颜色
    UIView *selectedBackgroundView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    selectedBackgroundView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"statusdetail_cell_sepatator.png"]];
    self.selectedBackgroundView =selectedBackgroundView;
    [selectedBackgroundView release];
}

-(void)setWeiboModel:(WeiboModel *)weiboModel{
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel =[weiboModel retain];
    }
    
    /**
     *  WXImageView 的点击点击手势回调方法。
     */
    __block WeiboCell *this =self;
    _userImage.touchBlock =^{
        NSString *userName =this.weiboModel.user.screen_name;
        UserViewController *userCtrl =[[UserViewController alloc]init];
        userCtrl.userName =userName;
        [this.viewController.navigationController pushViewController:userCtrl animated:YES];
        
    };
}



-(void)layoutSubviews {
    [super layoutSubviews];
    
    //-----------用户头像视图_userImage--------
    _userImage.frame =CGRectMake(5, 5, 35, 35);
    NSString *userImageUrl = _weiboModel.user.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    //昵称_nickLabel
    _nickLabel.frame =CGRectMake(50, 5, 200, 20);
    _nickLabel.text =_weiboModel.user.screen_name;
    
    //------------微博视图_weiboView--------------
    _weiboView.weiboModel =_weiboModel;
    //获取微博视图的高度
    float h =[WeiboView getWeiboViewHeight:_weiboModel isRepost:NO isDetail:NO];
    _weiboView.frame =CGRectMake(50, _nickLabel.bottom+20, kWeibo_Width_List, h);
    //调用weiboView的重新布局方法
    [_weiboView setNeedsLayout];
    
    
    //发布时间
    //源：Fri Aug 28 00:00:00 +0800 2009
    //E M d HH:mm:ss Z yyyy
    //目标：01-23 12:58
    NSString *createDate =_weiboModel.createDate;
    if (createDate != nil) {
        _createLabel.hidden =NO;
        NSString *dataString =[UIUtils fomateString:createDate]; //日期格式工具类
        _createLabel.text =dataString;
        _createLabel.frame =CGRectMake(_nickLabel.left, _nickLabel.bottom, 100, 20);
        [_createLabel sizeToFit];
    }else{
        _createLabel.hidden =YES;
    }
    
    //来源
    NSString *source=_weiboModel.source;
    //<a href="http://weibo.com" rel="nofollow">新浪微博</a>
    NSString *ret =[self parseSource:source];
    if (ret != nil) {
        _sourceLabel.hidden =NO;
        _sourceLabel.text =[NSString stringWithFormat:@"来自%@",ret];
        _sourceLabel.frame =CGRectMake(_createLabel.right+8, _nickLabel.bottom, 100, 20);
        [_sourceLabel sizeToFit];
    } else{
        _sourceLabel.hidden =YES;
    }
    
    //转发数
    NSNumber *repostsCount = _weiboModel.repostsCount;
    _repostCountLabel.text = [NSString stringWithFormat:@"转发数:%@",repostsCount];
    _repostCountLabel.frame =CGRectMake(_nickLabel.left, _weiboView.bottom+10, 100, 20);
    [_repostCountLabel sizeToFit];
    
    
    //评论数
    NSNumber *commentsCount = _weiboModel.commentsCount;
    _commentLabel.text = [NSString stringWithFormat:@"评论数:%@",commentsCount];
    _commentLabel.frame =CGRectMake(_repostCountLabel.right+10, _repostCountLabel.top, 100, 20);
    [_commentLabel sizeToFit];
}

//<a href="http://weibo.com" rel="nofollow">新浪微博</a>
- (NSString *)parseSource:(NSString *)source{
    NSString *regex = @">.+<";
    NSArray *arr =[source componentsMatchedByRegex:regex];
    if (arr.count >0) {
        // >新浪微博<
        NSString *ret =[arr objectAtIndex:0];
        NSRange range;
        range.location =1;
        range.length =ret.length-2;
        NSString *resultString =[ret substringWithRange:range];
        return resultString;
    }
    return nil;
}


@end
