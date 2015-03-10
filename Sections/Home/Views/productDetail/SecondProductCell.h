//
//  SecondProductCell.h
//  jiankemall
//
//  Created by kunge on 14/12/30.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondProductCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *useDrugBtn;
@property (strong, nonatomic) IBOutlet UIButton *addNoticeBtn;
@property (strong, nonatomic) IBOutlet UILabel *couponInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *ourPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *hasProductLabel;
@property (strong, nonatomic) IBOutlet UILabel *productNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *addNumberBtn;
@property (strong, nonatomic) IBOutlet UIButton *decadeNumberBtn;

@end
