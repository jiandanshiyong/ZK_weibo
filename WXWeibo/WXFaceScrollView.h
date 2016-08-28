//
//  WXFaceScrollView.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/17.
//  Copyright © 2016年 www.zhangkai2014bj.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXFaceView.h"

@interface WXFaceScrollView : UIView<UIScrollViewDelegate>{
    UIScrollView    *scrollView;
    WXFaceView      *faceView;
    UIPageControl   *pageControl;
}

- (id)initWithSelectBlock:(SelectBlock)block;

@end
