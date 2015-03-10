//
//  AccountInfoCell.h
//  jiankemall
//
//  Created by jianke on 14-12-18.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageview;
@property (strong, nonatomic) IBOutlet UITextField *contentField;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UITextField *diseaseField;

@end
