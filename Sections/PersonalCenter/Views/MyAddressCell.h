//
//  MyAddressCell.h
//  jiankemall
//
//  Created by jianke on 14-12-11.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAddressCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *defaultPic;
@property (strong, nonatomic) IBOutlet UILabel *telephoneNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *reciverNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIView *whiteView;

@end
