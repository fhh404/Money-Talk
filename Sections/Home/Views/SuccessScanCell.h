//
//  SuccessScanCell.h
//  jiankemall
//
//  Created by kunge on 15/1/6.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessScanCell : UITableViewCell
@property (strong, nonatomic) IBOutlet JKWebImageView *drugPic;
@property (strong, nonatomic) IBOutlet UILabel *drugName;
@property (strong, nonatomic) IBOutlet UILabel *guigeLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyLabel;
@property (strong, nonatomic) IBOutlet UILabel *ourPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *collectionBtn;
@property (strong, nonatomic) IBOutlet UIButton *buyNowBtn;
@property (strong, nonatomic) IBOutlet UIButton *addNoticeBtn;




@end
