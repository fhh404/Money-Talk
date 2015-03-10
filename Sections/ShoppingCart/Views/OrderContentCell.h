//
//  OrderContentCell.h
//  jiankemall
//
//  Created by kunge on 14/12/19.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet JKWebImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (strong, nonatomic) IBOutlet UILabel *productNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *detailBtn;
@property (strong, nonatomic) IBOutlet UILabel *marketPrice;
@property (strong, nonatomic) IBOutlet UILabel *productName;




@end
