//
//  DiseaseCell.h
//  jiankemall
//
//  Created by kunge on 14/12/29.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiseaseCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *ourPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *drugActionLabel;
@property (strong, nonatomic) IBOutlet UILabel *drugNameLabel;
@property (strong, nonatomic) IBOutlet JKWebImageView *drugImage;

@property (strong, nonatomic) IBOutlet UIButton *shopCartBtn;
@end
