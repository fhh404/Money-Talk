//
//  TypesDetailCell.h
//  jiankemall
//
//  Created by jianke on 14-12-17.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypesDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *standardLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyNamelabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (strong, nonatomic) IBOutlet JKWebImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *jionshopcartBtn;

@end
