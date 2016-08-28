//
//  WXFaceView.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/16.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSString *faceName);

@interface WXFaceView : UIView{
    NSMutableArray *items;
    UIImageView *magnifierView;
}

@property(nonatomic, copy)NSString *selectFaceName;
@property(nonatomic, assign)NSInteger *pageNum;

@property(nonatomic, copy)SelectBlock block;

@end
