//
//  OrderStateCell.h
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStateCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *payMoney;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;

@end
