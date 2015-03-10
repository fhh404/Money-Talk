//
//  FooterViewCell.h
//  jiankemall
//
//  Created by jianke on 14-12-18.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *newsBtn;
@property (strong, nonatomic) IBOutlet UIButton *messageBtn;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutlet UITextField *telephoneNumberField;
@property (strong, nonatomic) IBOutlet UIView *tipsView;
@property (strong, nonatomic) IBOutlet UIView *fieldBackView;

@end
