//
//  SendViewController.m
//  WXWeibo
//
//  Created by 张凯 on 14/2/13.
//  Copyright © 2014年 www.zhangkai2014bj.com. All rights reserved.
//

#import "SendViewController.h"
#import "UIFactory.h"
#import "NearbyViewController.h"
#import "BaseNavigationController.h"
#import "DataService.h"

@interface SendViewController ()

@end

@implementation SendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
   self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        
        self.isBackButton =NO;
        self.isCacelButton =YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    //显示键盘
    [self.textView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"发布新微博";
    _buttons =[[NSMutableArray alloc]initWithCapacity:6];
    
    UIButton *sendButton =[UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"发布" target:self action:@selector(sendAction)];
    UIBarButtonItem *sendItem =[[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem =sendItem;
    
    [self _initViews];
}

- (void)_initViews{
    self.textView.delegate =self;
    
    NSArray *imageNames =[NSArray arrayWithObjects:
                          @"compose_locatebutton_background.png",
                          @"compose_camerabutton_background.png",
                          @"compose_trendbutton_background.png",
                          @"compose_mentionbutton_background.png",
                          @"compose_emoticonbutton_background.png",
                          @"compose_keyboardbutton_background.png",
                          nil];
    NSArray *imageHighted =[NSArray arrayWithObjects:
                          @"compose_locatebutton_background_highlighted.png",
                          @"compose_camerabutton_background_highlighted.png",
                          @"compose_trendbutton_background_highlighted.png",
                          @"compose_mentionbutton_background_highlighted.png",
                          @"compose_emoticonbutton_background_highlighted.png",
                          @"compose_keyboardbutton_background_highlighted.png",
                          nil];
    
    
    for (int i=0; i<imageNames.count; i++) {
        NSString *imageName =[imageNames objectAtIndex:i ];
        NSString *hightedName =[imageHighted objectAtIndex:i ];
        
        UIButton *button =[UIFactory createButton:imageName highlighted:hightedName];
        [button setImage:[UIImage imageNamed:hightedName] forState:UIControlStateSelected];
        button.tag =(10+i);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame =CGRectMake(20+(64*i), 25, 23, 19);
        [self.editorBar addSubview:button];
        [_buttons addObject:button];
        
        if (i ==5) {
            button.hidden =YES;
            button.left -=64;
        }
    }
    
    //定位信息显示
    UIImage *image =[self.placeBackgoundView.image stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    self.placeBackgoundView.image =image;
    self.placeBackgoundView.width =200;
    
    self.placeLabel.left =35;
    self.placeLabel.width =160;
    
}
//显示表情面板
- (void)showFaceView{
    [self.textView resignFirstResponder];
    
    if (_faceView ==nil) {
        
        __block SendViewController *this =self;
        _faceView = [[WXFaceScrollView alloc] initWithSelectBlock:^(NSString *faceName) {
            NSString *text = this.textView.text;
            NSString *appendText =[text stringByAppendingString:faceName];
            this.textView.text =appendText;
        }];
        
        
        
        _faceView.top =ScreenHeight-_faceView.height;
        _faceView.transform =CGAffineTransformTranslate(_faceView.transform, 0, ScreenHeight);
        [self.view addSubview:_faceView];
        
    }
    
    UIButton *faceButton =_buttons[4];
    UIButton *keyboard =_buttons[5];
    faceButton.alpha =1;
    keyboard.alpha =0;
    keyboard.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _faceView.transform =CGAffineTransformIdentity;
        faceButton.alpha =0;
        
        //调整、适应键盘的高度
        self.editorBar.bottom =ScreenHeight-_faceView.height;
        self.textView.height =self.editorBar.top;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            keyboard.alpha =1;
        }];
    }];
    
    
}

//显示键盘
- (void)showKeyboard{
    [self.textView becomeFirstResponder];
    
    UIButton *faceButton =_buttons[4];
    UIButton *keyboard =_buttons[5];
    keyboard.alpha =1;
    faceButton.alpha =0;
    [UIView animateWithDuration:0.3 animations:^{
        _faceView.transform =CGAffineTransformTranslate(_faceView.transform, 0, ScreenHeight-44-20);
        keyboard.alpha =0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            faceButton.alpha =1;
        }];
    }];
    
}

#pragma mark - Data
- (void)doSendData{
    [super showStatusTips:YES title:@"正在发送中..."];
    
    NSString *text =self.textView.text;
    
    if (text.length ==0) {
        NSLog(@"微博内容为空");
        return;
    }
    
    NSMutableDictionary *params =[NSMutableDictionary  dictionaryWithObject:text forKey:@"status"];
    
    if (self.longitude.length >0) {
        [params setObject:self.longitude forKey:@"long"];
    }
    if (self.latitude.length >0) {
        [params setObject:self.latitude forKey:@"lat"];
    }
    
    if (self.sendImage ==nil) {
        //不带图片
        [self.sinaweibo requestWithURL:URL_UPDATE params:params
                            httpMethod:@"POST" block:^(NSDictionary *result) {
                                     [super showStatusTips:NO title:@"发送成功!"];
                                     [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        //使用照片
        NSData *data =UIImageJPEGRepresentation(self.sendImage, 0.3);
        [params setObject:data forKey:@"pic"];
        
//        [self.sinaweibo requestWithURL:@"statuses/upload.json" params:params
//                            httpMethod:@"POST" block:^(NSDictionary *result) {
//                                [super showStatusTips:NO title:@"发送成功!"];
//                                [self dismissViewControllerAnimated:YES completion:nil];
//        }];
        
        [DataService requestWithURL:URL_UPLOAD params:params httpMethod:@"POST" completeBlock:^(id result) {
            [super showStatusTips:NO title:@"发送成功!"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}


#pragma mark - Actions

- (void)sendAction{
//    NSLog(@"发布微博");
    
    [self doSendData];
    
}

- (void)buttonAction:(UIButton *)button{
    
    if (button.tag ==10) {
        //位置定位
        [self location];
    }
    else if (button.tag ==11) {
        //照片
        [self selectImage];
    }
    else if (button.tag ==12) {
        //#话题#
    }
    else if (button.tag ==13) {
        //@用户
    }
    else if (button.tag ==14) {
        //显示表情
        [self showFaceView];
    }
    else if (button.tag ==15) {
        //显示键盘
        [self showKeyboard];
    }

}

//定位
- (void)location{
    NearbyViewController *nearbyCtrl =[[NearbyViewController alloc]init];
    BaseNavigationController *baseNav =[[BaseNavigationController alloc]initWithRootViewController:nearbyCtrl];
    [self presentViewController:baseNav animated:YES completion:nil];
    
    nearbyCtrl.selectBlock =^(NSDictionary *result){
        //记录位置坐标
        _longitude =[result objectForKey:@"lon"];
        _latitude =[result objectForKey:@"lat"];
        
        NSString *address =[result objectForKey:@"address"];
        if ([address isKindOfClass:[NSNull class]] || address.length ==0) {
            address =[result objectForKey:@"title"];
        }
        
        self.placeLabel.text =address;
        self.placeView.hidden =NO;
        
        UIButton *locationButton=[_buttons objectAtIndex:0];
        locationButton.selected =YES;
    };
}

//使用相片
- (void)selectImage{
    [self.textView resignFirstResponder];
    
    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"用户相册", nil];
    [actionSheet showInView:self.view];

}

//全频放大图片
- (void)imageAction:(UIImage *)image{
    if (_fullImageView == nil) {
        _fullImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _fullImageView.backgroundColor = [UIColor blackColor];
        _fullImageView.userInteractionEnabled =YES;
        _fullImageView.contentMode =UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageAction:)];
        [_fullImageView addGestureRecognizer:tap];
        
        //创建删除按钮
        UIButton *deleteButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed: @"trash.png"] forState:UIControlStateNormal ];
        deleteButton.frame =CGRectMake(280, 40, 20, 26);
        deleteButton.tag =100;
        deleteButton.hidden =YES;
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [_fullImageView addSubview:deleteButton];
    }
    
    [self.textView resignFirstResponder];
    //图片放大
    if (![_fullImageView superview]) {
        _fullImageView.image =self.sendImage;
        [self.view.window addSubview:_fullImageView];
        
        _fullImageView.frame =CGRectMake(5, ScreenHeight-240, 20, 20);
        [UIView animateWithDuration:.4 animations:^{
            _fullImageView.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        }completion:^(BOOL finished) {
            [UIApplication sharedApplication].statusBarHidden =YES;
            //显示删除按钮
            [_fullImageView viewWithTag:100].hidden =NO;
        }];
    }
}

//点击手势 图片缩小 移除UIImageView
- (void)scaleImageAction:(UITapGestureRecognizer *)tap{
    //隐藏删除按钮
    [_fullImageView viewWithTag:100].hidden =YES;
    
    [UIView animateWithDuration:0.4 animations:^{
       _fullImageView.frame =CGRectMake(5, ScreenHeight-250, 20, 20);
    } completion:^(BOOL finished) {
        [_fullImageView removeFromSuperview];
    }];
    
    [UIApplication sharedApplication].statusBarHidden =NO;
    [self.textView becomeFirstResponder];
}

//取消选择的图片
- (void)deleteAction:(UIButton *)deleteButton{
    //缩小
    [self scaleImageAction:nil];
    //移除缩略图按钮
    [self.sendImageButton removeFromSuperview];
    self.sendImage =nil;
    
    //工具栏上的左边的两个按钮，恢复位置
    UIButton *button1 = [_buttons objectAtIndex:0];
    UIButton *button2 = [_buttons objectAtIndex:1];
    [UIView animateWithDuration:0.5 animations:^{
        button1.transform =CGAffineTransformIdentity;
        button2.transform =CGAffineTransformIdentity;
    }];
}

#pragma mark - UITextView Dalegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //显示为表情按钮
    UIButton *faceButton =_buttons[4];
    UIButton *keyboard =_buttons[5];
    keyboard.alpha =1;
    faceButton.alpha =0;
    [UIView animateWithDuration:0.3 animations:^{
        keyboard.alpha =0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            faceButton.alpha =1;
        }];
    }];
    
    return YES;
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex ==0) {
        //判断是否有摄像头
        BOOL isCamera =[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        //拍照
        sourceType =UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex ==1){
        //用户相册
        sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else {
        [self.textView becomeFirstResponder];
        //取消
        return;
    }
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc]init];
    imagePicker.sourceType =sourceType;
    imagePicker.delegate =self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate
//选择相册、拍照 之后调用的协议方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取原图
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.sendImage =image;
    
    //创建图片缩略图按钮
    if (self.sendImageButton ==nil) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius =5;
        button.layer.masksToBounds =YES;
        button.frame =CGRectMake(5, 20, 25, 25);
        [button addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
        self.sendImageButton =button;
    }
    
    //设置图片缩略图
    [self.sendImageButton setImage:image forState:UIControlStateNormal];
    [self.editorBar addSubview:self.sendImageButton];
    
    //工具栏上的左边的两个按钮，向右移动
    UIButton *button1 = [_buttons objectAtIndex:0];
    UIButton *button2 = [_buttons objectAtIndex:1];
    [UIView animateWithDuration:0.5 animations:^{
        button1.transform =CGAffineTransformTranslate(button1.transform, 20, 0);
        button2.transform =CGAffineTransformTranslate(button2.transform, 5, 0);
    }];
    
    // 关闭选择图片页面
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSNotification
//键盘将要出现的通知方法
- (void)keyboardShowNotification:(NSNotification *)notification{
    
    //获取键盘的高度
    NSValue *keyboardValue =[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame=[keyboardValue CGRectValue];
    float height =frame.size.height;
    
    //调整、适应键盘的高度
    self.editorBar.bottom =ScreenHeight-height;
    self.textView.height =self.editorBar.top;
}


#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_textView release];
    [_editorBar release];
    [_placeView release];
    [_placeBackgoundView release];
    [_placeLabel release];
    [super dealloc];
}

@end
