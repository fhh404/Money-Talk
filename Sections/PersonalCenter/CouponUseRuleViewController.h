//
//  CouponUseRuleViewController.h
//  jiankemall
//
//  Created by kunge on 14/12/25.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponUseRuleViewController : JKViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *couponRuleTable;

@end
