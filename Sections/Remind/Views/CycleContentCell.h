//
//  CycleContentCell.h
//  jiankemall
//
//  Created by jianke on 14-12-18.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleContentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *daysBtn;
@property (strong, nonatomic) IBOutlet UILabel *daysLabel;
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) IBOutlet UIButton *dateCycleBtn;
@property (strong, nonatomic) IBOutlet UILabel *currentDayLabel;

@end
