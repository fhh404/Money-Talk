//
//  RegisterViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : JKViewController<JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UITextField *telephoneField;
@property (strong, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (strong, nonatomic) IBOutlet UILabel *emailRegisterLabel;

@end
