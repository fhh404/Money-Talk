//
//  DoctorRecommendationViewController.h
//  jiankemall
//
//  Created by kunge on 14/12/31.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorRecommendationViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>

@property (strong,nonatomic)NSString *teamId;
@end
