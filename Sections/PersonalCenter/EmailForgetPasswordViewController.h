//
//  EmailForgetPasswordViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-16.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailForgetPasswordViewController : JKViewController<JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UILabel *serviceLabel;
@property (strong, nonatomic) IBOutlet UIButton *foundBackBtn;
@property (strong, nonatomic) IBOutlet UIView *fieldBackView;
@property (strong, nonatomic) IBOutlet UITextField *emailField;

@property NSString *feildTxt;
@end
