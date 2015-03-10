//
//  FourthProductCell.h
//  jiankemall
//
//  Created by kunge on 14/12/30.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourthProductCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *itemNumberLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *productScrollow;
@property (strong, nonatomic) IBOutlet UILabel *suitPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *savingPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyNowBtn;
@property (strong, nonatomic) IBOutlet UIButton *checkMoreBtn;
@property (strong, nonatomic) IBOutlet UIView *lightGrayView;
@property (strong, nonatomic) IBOutlet UIImageView *backGrayImage;

@end
