//
//  UserEvaluteCell.h
//  jiankemall
//
//  Created by kunge on 15/1/28.
//  Copyright (c) 2015年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserEvaluteCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *fristStarImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondStarImage;
@property (strong, nonatomic) IBOutlet UIImageView *thirdStarImage;
@property (strong, nonatomic) IBOutlet UIImageView *fouthStarImage;
@property (strong, nonatomic) IBOutlet UIImageView *fifthStarImage;
@property (strong, nonatomic) IBOutlet UILabel *numbersLabel;
@property (strong, nonatomic) IBOutlet UILabel *evaluteContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
