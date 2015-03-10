//
//  ReminderCell.h
//  jiankemall
//
//  Created by jianke on 14-12-10.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIButton *switchBtn;
@property (strong, nonatomic) IBOutlet UIView *whiteView;



@end
