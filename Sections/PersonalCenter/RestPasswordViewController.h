//
//  RestPasswordViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-16.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestPasswordViewController : JKViewController<JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UITextField *firstPasswordField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong, nonatomic) IBOutlet UIView *tipsView;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;

@property(strong,nonatomic)NSString *loginTelephone;
@end
