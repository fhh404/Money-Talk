//
//  AddressDetailCell.h
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *recivePerson;
@property (strong, nonatomic) IBOutlet UILabel *telephoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *sellerID;

@property (strong, nonatomic) IBOutlet UILabel *orderNumber;
@property (strong, nonatomic) IBOutlet UILabel *creatTime;
@property (strong, nonatomic) IBOutlet UILabel *payTime;

@property (strong, nonatomic) IBOutlet UIButton *onlineBtn;





@end
