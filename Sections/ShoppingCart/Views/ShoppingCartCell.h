//
//  ShoppingCartCell.h
//  jiankemall
//
//  Created by jianke on 14-12-11.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *plusBtn;
@property (strong, nonatomic) IBOutlet UILabel *productNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *reduceBtn;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productIntroductionLabel;
@property (strong, nonatomic) IBOutlet UILabel *productPrice;
@property (strong, nonatomic) IBOutlet JKWebImageView *productPic;
@property (strong, nonatomic) IBOutlet UIView *imageBackView;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (strong, nonatomic) IBOutlet UILabel *iconMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *reduceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *reducebackImage;
@property (strong, nonatomic) IBOutlet UILabel *productMarket;





@end
