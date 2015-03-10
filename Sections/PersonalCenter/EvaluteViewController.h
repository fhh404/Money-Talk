//
//  EvaluteViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-4.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluteViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UITableView *evaluteTable;
@property (strong, nonatomic) IBOutlet UIView *evaluteFrameVIew;



@property NSString *productID;
@end
