//
//  NameChangeViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameChangeViewController : JKViewController<JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong, nonatomic) IBOutlet UITextField *inputField;

@end
