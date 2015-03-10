//
//  DoctorRecommentionCell.h
//  jiankemall
//
//  Created by kunge on 14/12/31.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorRecommentionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *goumaiBtn;
@property (strong, nonatomic) IBOutlet UILabel *ourPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *restPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *productScrollow;
@property (strong, nonatomic) IBOutlet UIButton *doctorBtn;


@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UIView *grayView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@end
