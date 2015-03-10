//
//  SettingViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-15.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : JKViewController

@property (strong, nonatomic) IBOutlet UIView *newsView;
@property (strong, nonatomic) IBOutlet UIButton *loginOutBtn;

@property (strong, nonatomic) IBOutlet UIButton *highImageSwitchBtn;
@property (strong, nonatomic) IBOutlet UIButton *telephoneNumberBtn;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UIView *aboutUsView;
@property (strong, nonatomic) IBOutlet UIView *feedBackView;
@property (strong, nonatomic) IBOutlet UIView *versionUpdateView;

@end
