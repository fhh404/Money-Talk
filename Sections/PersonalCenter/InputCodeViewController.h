//
//  InputCodeViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputCodeViewController : JKViewController<JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UIButton *rePostBtn;
@property (strong, nonatomic) IBOutlet UITextField *messageInputField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *affiarPasswordField;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (strong, nonatomic) IBOutlet UILabel *protoclLabel;
@property (strong, nonatomic) IBOutlet UIButton *resigerBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *contentSrollow;


@property(strong,nonatomic)NSString *telephoneNumber;

@end
