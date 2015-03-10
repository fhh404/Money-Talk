//
//  UserEvaluteViewController.h
//  jiankemall
//
//  Created by kunge on 14/12/31.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserEvaluteViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>

@property (strong, nonatomic) IBOutlet UILabel *totalEvaluters;
@property (strong, nonatomic) IBOutlet UILabel *totalStars;
@property (strong, nonatomic) IBOutlet UIView *totalBackView;

@property (strong,nonatomic)NSString *priductId;
@end
