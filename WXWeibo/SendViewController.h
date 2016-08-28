//
//  SendViewController.h
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "BaseViewController.h"
#import "WXFaceScrollView.h"

@interface SendViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate>{
    NSMutableArray *_buttons;
    
    //全屏显示图片视图
    UIImageView *_fullImageView;
    
    //表情视图
    WXFaceScrollView *_faceView;
}

//send Data
//经度
@property(nonatomic, copy)NSString *longitude;
//维度
@property(nonatomic, copy)NSString *latitude;
//发送的图片
@property(nonatomic, retain)UIImage *sendImage;

//图片缩略图视图
@property(nonatomic, retain)UIButton *sendImageButton;

//编辑输入框
@property (retain, nonatomic) IBOutlet UITextView *textView;
//工具栏
@property (retain, nonatomic) IBOutlet UIView *editorBar;

@property (retain, nonatomic) IBOutlet UIView *placeView;
@property (retain, nonatomic) IBOutlet UIImageView *placeBackgoundView;
@property (retain, nonatomic) IBOutlet UILabel *placeLabel;


@end
