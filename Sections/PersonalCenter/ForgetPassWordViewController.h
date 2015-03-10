//
//  ForgetPassWordViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPassWordViewController : JKViewController<JsonRequestDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *phoneAndAddressField;
@property (strong, nonatomic) IBOutlet UITextField *codeField;
@property (strong, nonatomic) IBOutlet UILabel *serviceTelephoneLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UILabel *postBtnLabel;

@end
