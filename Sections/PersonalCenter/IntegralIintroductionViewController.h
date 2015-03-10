//
//  IntegralIintroductionViewController.h
//  jiankemall
//
//  Created by kunge on 14/12/23.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralIintroductionViewController : JKViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *integralNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;



@property (nonatomic, strong) UIScrollView *scrollView;
@property NSString *integralNumber;

@end
