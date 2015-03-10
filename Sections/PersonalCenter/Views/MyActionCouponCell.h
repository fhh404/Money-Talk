//
//  MyActionCouponCell.h
//  jiankemall
//
//  Created by jianke on 14-12-8.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActionCouponCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *couponID;
@property (strong, nonatomic) IBOutlet UILabel *useRuleLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemLabel;
@property (strong, nonatomic) IBOutlet UILabel *orginalLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *couponPriceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backCouponImage;
@property (strong, nonatomic) IBOutlet UIView *grayView;
@property (strong, nonatomic) IBOutlet UIView *whiteView;

@end
