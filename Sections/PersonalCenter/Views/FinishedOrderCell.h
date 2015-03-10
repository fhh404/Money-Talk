//
//  FinishedOrderCell.h
//  jiankemall
//
//  Created by jianke on 14-12-3.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishedOrderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderNumber;
@property (strong, nonatomic) IBOutlet UILabel *orderPrice;
@property (strong, nonatomic) IBOutlet UILabel *orderState;
@property (strong, nonatomic) IBOutlet UILabel *orderAmount;
@property (strong, nonatomic) IBOutlet UILabel *orderTime;
@property (strong, nonatomic) IBOutlet UIButton *arrowBtn;
@property (strong, nonatomic) IBOutlet UIButton *blueBtn;
@property (strong, nonatomic) IBOutlet UIButton *whiteBtn;
@property (strong, nonatomic) IBOutlet UILabel *blueBtnLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteBtnLabel;
@property (strong, nonatomic) IBOutlet UILabel *flagLabel;
@property (strong, nonatomic) IBOutlet JKWebImageView *productImage;

@end
