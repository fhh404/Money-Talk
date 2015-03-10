//
//  PassWordChangeViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassWordChangeViewController : JKViewController<JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIView *thirdView;
@property (strong, nonatomic) IBOutlet UITextField *currentField;
@property (strong, nonatomic) IBOutlet UITextField *repeatNewPasswordField;
@property (strong, nonatomic) IBOutlet UITextField *newpasswordfield;

@end
