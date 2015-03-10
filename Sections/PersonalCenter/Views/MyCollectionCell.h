//
//  MyCollectionCell.h
//  jiankemall
//
//  Created by jianke on 14-12-8.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet JKWebImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *currentPrice;
@property (strong, nonatomic) IBOutlet UILabel *originalPrice;
@property (strong, nonatomic) IBOutlet UIImageView *grayLine;
@property (strong, nonatomic) IBOutlet UILabel *depreciateLabel;
@property (strong, nonatomic) IBOutlet UIButton *notificationBtn;
@property (strong, nonatomic) IBOutlet UIButton *immediateBuyBtn;

@end
