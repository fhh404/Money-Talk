//
//  VoiceViewController.h
//  jiankemall
//
//  Created by kunge on 15/1/21.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

//forward declare
@class PopupView;
@class IFlyDataUploader;
@class IFlySpeechRecognizer;

/**
 无UI语音识别demo
 使用该功能仅仅需要四步
 1.创建识别对象；
 2.设置识别参数；
 3.有选择的实现识别回调；
 4.启动识别
 */

@interface VoiceViewController : UIViewController<IFlySpeechRecognizerDelegate,UIActionSheetDelegate>

//识别对象
@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;

//数据上传对象
@property (nonatomic, strong) IFlyDataUploader     * uploader;

@property (nonatomic, weak)   UITextView           * resultView;
@property (nonatomic, strong) PopupView            * popUpView;
@property (nonatomic, weak)   UIButton             * startBtn;
@property (nonatomic, weak)   UIButton             * stopBtn;
@property (nonatomic, weak)   UIButton             * cancelBtn;
@property (nonatomic, weak)   UIButton             * uploadWordBtn;
@property (nonatomic, weak)   UIButton             * uploadContactBtn;

@property (nonatomic, strong) NSString             * result;
@property (nonatomic)         BOOL                 isCanceled;

@property (strong, nonatomic) IBOutlet UIImageView *voiceImage;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;


- (void) onBtnStart:(id) sender;
@end
