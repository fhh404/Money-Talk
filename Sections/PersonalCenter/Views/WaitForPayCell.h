//
//  WaitForPayCell.h
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitForPayCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderID;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (strong, nonatomic) IBOutlet JKWebImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productPrice;
@property (strong, nonatomic) IBOutlet UILabel *orderstate;
@property (strong, nonatomic) IBOutlet UILabel *orderAmount;
@property (strong, nonatomic) IBOutlet UILabel *orderTime;
@property (strong, nonatomic) IBOutlet UILabel *iconmoneyLabel;

@end
