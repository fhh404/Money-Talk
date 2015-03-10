//
//  IntegralSummary Cell.h
//  jiankemall
//
//  Created by jianke on 14-12-8.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralSummary_Cell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *allIntegralLabel;
@property (strong, nonatomic) IBOutlet UILabel *useableIntegralLabel;

@property (strong, nonatomic) IBOutlet UILabel *expensesIntegralLabel;
@property (strong, nonatomic) IBOutlet UILabel *checkIntegralIntroduction;
@property (strong, nonatomic) IBOutlet UILabel *integralExchangeCoupon;
@property (strong, nonatomic) IBOutlet UILabel *periodLabel;

@property (strong, nonatomic) IBOutlet UILabel *tempLabel;


@end
