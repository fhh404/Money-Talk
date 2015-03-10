//
//  OrderDetailCell.h
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *productPic;

@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productStandard;
@property (strong, nonatomic) IBOutlet UILabel *productAmount;
@property (strong, nonatomic) IBOutlet UILabel *productPrice;

@property (strong, nonatomic) IBOutlet UIButton *arrowBtn;


@end
