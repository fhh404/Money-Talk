//
//  ChinaAndForeginDrugCell.h
//  jiankemall
//
//  Created by kunge on 14/12/29.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChinaAndForeginDrugCell : UITableViewCell
@property (strong, nonatomic) IBOutlet JKWebImageView *leftImage;
@property (strong, nonatomic) IBOutlet UILabel *leftnameLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftUselabel;
@property (strong, nonatomic) IBOutlet UILabel *leftOurPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftMarketPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftCheckBtn;

@property (strong, nonatomic) IBOutlet JKWebImageView *rightImage;
@property (strong, nonatomic) IBOutlet UILabel *rightNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightUseLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightOurPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightMarketPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *rightCheckBtn;





@end
