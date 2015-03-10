//
//  EvaluteCell.h
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluteCell : UITableViewCell
@property (strong, nonatomic) IBOutlet JKWebImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productAmount;
@property (strong, nonatomic) IBOutlet UIButton *firstStarBtn;
@property (strong, nonatomic) IBOutlet UIButton *secondStarBtn;
@property (strong, nonatomic) IBOutlet UIButton *thirdStarBtn;
@property (strong, nonatomic) IBOutlet UIButton *fourthStarBtn;
@property (strong, nonatomic) IBOutlet UIButton *fifthStarBtn;
@property (strong, nonatomic) IBOutlet UITextView *EvaluteTextView;


@end
