//
//  FeedBackViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-15.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : JKViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *inputContenView;
@property (strong, nonatomic) IBOutlet UIView *telephoneinputVIew;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UITextField *telephoneField;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

@end
