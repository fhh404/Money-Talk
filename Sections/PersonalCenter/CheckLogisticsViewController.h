//
//  CheckLogisticsViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-15.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckLogisticsViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>

@property (strong, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *expressNumber;
@property (strong, nonatomic) IBOutlet UIView *totalBackview;

@property NSString *trackingNum;
@end
