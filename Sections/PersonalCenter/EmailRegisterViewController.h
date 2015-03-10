//
//  EmailRegisterViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailRegisterViewController : JKViewController<JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UILabel *protocolLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailFiled;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxBtn;

@end
