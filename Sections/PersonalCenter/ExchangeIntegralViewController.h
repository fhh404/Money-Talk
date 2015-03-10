//
//  ExchangeIntegralViewController.h
//  jiankemall
//
//  Created by kunge on 14/12/23.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeIntegralViewController : JKViewController<JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UIButton *fiveyuanBtn;
@property (strong, nonatomic) IBOutlet UIButton *tenyuanBtn;
@property (strong, nonatomic) IBOutlet UIButton *twentyyuanBtn;
@property (strong, nonatomic) IBOutlet UIButton *fiftyyuanBtn;
@property (strong, nonatomic) IBOutlet UIButton *exchangeBtn;
@property (strong, nonatomic) IBOutlet UILabel *integralNumberLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollow;

@property NSString *integralNumber;
@end
