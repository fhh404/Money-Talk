//
//  WaitForPayViewController.h
//  jiankemall
//
//  Created by jianke on 14-12-5.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitForPayViewController : JKViewController<UITableViewDataSource,UITableViewDelegate,JsonRequestDelegate>
@property (strong, nonatomic) IBOutlet UILabel *amountPrice;
@property (strong, nonatomic) IBOutlet UILabel *AmountLabel;
@property (strong, nonatomic) IBOutlet UIButton *allCheckBoxBtn;
@property (strong, nonatomic) IBOutlet UIView *jiesuanBackView;

@end
